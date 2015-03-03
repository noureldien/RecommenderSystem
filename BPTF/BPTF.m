% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [Us Vs Ts rmseTe alpha] = BPTF(TTr, TTe, D, hyper_params, init, options)
%[Us Vs Ts] = BPTF(TTr, TTe, D, hyper_params, init, max_iter, n_sample, run_name)
% full bayesian probabilistic tensor factorization
% TTr: training tensor
% TTe: testing tensor
% D: feature dimension
% hyper_params: hyper parameters: (nuAlpha, Walpha, mu, muT, nu, beta, W, WT)
%       refer to the report for details
%       if nuAlpha=0, then the value of alpha is fixed at the value of Walpha
% init: initalization value: (U, V, T). if a scalar, then
% the sampling will start from the existing sample. The sample
% number will follow the given sample, which will overwrite the
% original subsequent ones.
% max_iter: maximum number of samples to draw
% n_sample: # samples used to calculate the result. if <= 0, then
% samples will be output to files
% run_name: the name of this run. used for sample files.
% Us, Vs, Ts: factor samples. each column is a sample. need reshape
% before use.

if nargin < 6; options = []; end
[max_iter save_sample n_sample, run_name] = GetOptions(options,...
    'max_iter',50,'save_sample',false,'n_sample',50,'run_name','');

if save_sample
    sample_file_format = GetSampleFileFormat('t');
end

%sizes
[M N K] = size(TTr);

%priors
[nuAlpha Walpha mu0 mu0T nu0 beta0 W0 W0T] = GetOptions(hyper_params,...
    'nuAlpha',1, 'Walpha',1, 'mu',0, 'muT',1, 'nu',D, 'beta',1, 'W',eye(D), 'WT', eye(D));
iWalpha = inv(Walpha);
iW0 = inv(W0);
iW0T = inv(W0T);

%tensor data
subs = TTr.subs;
assert(all(min(subs) >= 1));
assert(all(max(subs) <= [M N K]));
vals = TTr.vals;
L = length(vals);
clear TTr;

fprintf('Bayesian PTF for tensor (%d, %d, %d):%d. D = %d.\n', M, N, K, L, D);
fprintf('nu_alpha=%g, W_alpha=%g, mu=%g, mu_T=%g, nu=%g, beta=%g, W=%g, W_T=%g\n', ...
        nuAlpha, Walpha, mu0(1), mu0T(1), nu0, beta0, W0(1,1), W0T(1,1));

fprintf('Initialization...');
sample_idx = 1;
if isempty(init)
    U = randn(D, M)*0.1;
    V = randn(D, N)*0.1;
    T = randn(D, K)*0.1;
elseif iscell(init)
    [U V T] = cell2vars(init);clear init;
    assert(size(U,1) == D);
else
  assert(save_sample);
  fprintf('Continue from sample %d...', init);U=[];V=[];T=[];
  load(sprintf(sample_file_format, run_name, D, init));
  sample_idx = init + 1;
  
  assert(n_sample<=0, 'can only generate sample when start from samples');
  assert(all(size(U)==[D M]));
  assert(all(size(V)==[D N]));
  assert(all(size(T)==[D K]));
end

te = ~isempty(TTe);

if te
  subsTe = TTe.subs;
  valsTe = TTe.vals;
  LTe = length(valsTe);
  clear TTe;
end

rmseTe = nan;
yTr = PTF_Reconstruct(subs, U, V, T);
rmseTr = RMSE(yTr - vals);
if te
    yTe = PTF_Reconstruct(subsTe, U, V, T);
    rmseTe = RMSE(yTe - valsTe);
end

fprintf('complete. RMSE = %0.4f/%0.4f.\n', rmseTr, rmseTe);

%sample buffer
if n_sample > 0
  ysTr = zeros(L, n_sample);
  if te
    ysTe = zeros(LTe, n_sample);
  end
  Us = zeros(D*M, n_sample);
  Vs = zeros(D*N, n_sample);
  Ts = zeros(D*K, n_sample);
end

fprintf('Pre-calculating the index...');
subU = subs(:, 1);
subV = subs(:, 2);
subT = subs(:, 3);
fprintf('U');subU_bag = GroupIndex(subU, M);
fprintf('V');subV_bag = GroupIndex(subV, N);
fprintf('T');subT_bag = GroupIndex(subT, K);
subVU_bag = cell(1, M);subTU_bag = cell(1, M);valsU_bag = cell(1, M);
for ind = 1:M
    subVU_bag{ind} = subV(subU_bag{ind});
    subTU_bag{ind} = subT(subU_bag{ind});
    valsU_bag{ind} = vals(subU_bag{ind});
end
subUV_bag = cell(1, N);subTV_bag = cell(1, N);valsV_bag = cell(1, N);
for ind = 1:N
    subUV_bag{ind} = subU(subV_bag{ind});
    subTV_bag{ind} = subT(subV_bag{ind});
    valsV_bag{ind} = vals(subV_bag{ind});
end
subUT_bag = cell(1, K);subVT_bag = cell(1, K);valsT_bag = cell(1, K);
for ind = 1:K
    subUT_bag{ind} = subU(subT_bag{ind});
    subVT_bag{ind} = subV(subT_bag{ind});
    valsT_bag{ind} = vals(subT_bag{ind});
end
clear subU subV subT subU_bag subV_bag subT_bag
fprintf('. complete.\n');

if save_sample
    save(sprintf(sample_file_format, run_name, D, sample_idx - 1), 'U', 'V', 'T');
end
      
alpha = Walpha;%precision for users
tic;
for iter = sample_idx:(sample_idx + max_iter - 1)
    fprintf('-Iter%d... ', iter);
    
    %sample the prior of alpha
    if nuAlpha < 0
        if iter > -nuAlpha
            nuAlpha = 1;
        end
    end
    if nuAlpha > 0
      nualpha_ = nuAlpha + L;
      iWalpha_ = iWalpha + sum((vals - yTr).^2);
      alpha = wishrnd(1./iWalpha_, nualpha_);
    end
    
    %sample the prior of U
    Umean = mean(U, 2);
    beta0_ = beta0 + M;
    mu0_ = (beta0*mu0 + M*Umean)/beta0_;
    nu0_ = nu0 + M;
    dMu = mu0 - Umean;
    iW0_ = iW0 + U*U' - M*(Umean*Umean') + (beta0*M/beta0_)*(dMu*dMu');
    
    W0_ = inv(iW0_);
    A_U = wishrnd((W0_ + W0_')*0.5, nu0_);
    mu_U = mvnrndpre(mu0_, beta0_*A_U);
    
    %sample the prior of V
    Vmean = mean(V, 2);
    beta0_ = beta0 + N;
    mu0_ = (beta0*mu0 + N*Vmean)/beta0_;
    nu0_ = nu0 + N;
    dMu = mu0 - Vmean;
    iW0_ = iW0 + V*V' - N*(Vmean*Vmean') + (beta0*N/beta0_)*(dMu*dMu');
    
    W0_ = inv(iW0_);
    A_V = wishrnd((W0_ + W0_')*0.5, nu0_);
    mu_V = mvnrndpre(mu0_, beta0_*A_V);
    
    %sample the prior of T
    beta0_ = beta0 + 1;
    mu0_ = (T(:, 1) + beta0*mu0T)/beta0_;
    nu0_ = nu0 + K;
    dT = diff(T, 1, 2);
    dTe = T(:, 1) - mu0T;
    iW0_ = iW0T + dT*dT' + (beta0/beta0_)*(dTe*dTe');
    
    W0_ = inv(iW0_);
    A_T = wishrnd((W0_ + W0_')*0.5, nu0_);
    mu_T = mvnrndpre(mu0_, beta0_*A_T);
    
    fprintf('U');
    parfor ind = 1:M
        U(:, ind) = UpdateFactor(alpha, A_U, mu_U, ...
            PTF_ComputeQ(V, T, subVU_bag{ind}, subTU_bag{ind}), valsU_bag{ind});
    end
    
    fprintf('V');
    parfor jnd = 1:N
        V(:, jnd) = UpdateFactor(alpha, A_V, mu_V, ...
            PTF_ComputeQ(U, T, subUV_bag{jnd}, subTV_bag{jnd}), valsV_bag{jnd});
    end
    
    fprintf('T');
    for knd = 1:K
        if isempty(valsT_bag{knd}); 
            QQ = 0;RQ = 0;
        else
            Q = PTF_ComputeQ(U, V, subUT_bag{knd}, subVT_bag{knd});
            QQ = Q*Q';
            RQ = Q*valsT_bag{knd};
        end
        
        switch knd
            case 1,
                Ak_ = 2*A_T + alpha*QQ;
                muk_ = Ak_\(A_T*(T(:, 2) + mu_T) + alpha*RQ);
            case K,
                Ak_ = A_T + alpha*QQ;
                muk_ = Ak_\(A_T*T(:, K-1) + alpha*RQ);
            otherwise,
                Ak_ = 2*A_T + alpha*QQ;
                muk_ = Ak_\(A_T*sum(T(:, [knd-1, knd+1]), 2) + alpha*RQ);
        end
        
        T(:, knd) = mvnrndpre(muk_, Ak_);
    end
    
    %record samples
    count = mod(iter - 1, n_sample) + 1;
    if save_sample
        save(sprintf(sample_file_format, run_name, D, iter), ...
            'alpha', 'U', 'V', 'T', 'A_U', 'mu_U', 'A_V', 'mu_V', 'A_T', 'mu_T');
    end
    
    Us(:, count) = U(:);
    Vs(:, count) = V(:);
    Ts(:, count) = T(:);

    ysTr(:, count) = PTF_Reconstruct(subs, U, V, T);
    yTr = mean(ysTr(:, 1:min(iter, n_sample)), 2);
    rmseTr = RMSE(yTr - vals);
    
    rmseTe = nan;
    if te
      ysTe(:, count) = PTF_Reconstruct(subsTe, U, V, T);
      yTe = mean(ysTe(:, 1:min(iter, n_sample)), 2);
      rmseTe = RMSE(yTe - valsTe);
    end
    
    fprintf('. alpha = %g. Using %d samples. RMSE=%0.4f/%0.4f. ETA=%0.2f hr\n', ...
        alpha, min(iter, n_sample), rmseTr, rmseTe,...
        (max_iter + sample_idx - 1 - iter)*toc/(iter - sample_idx + 1)/3600);
end

function [r] = UpdateFactor(alpha, A, mu, Q, vv)

if isempty(vv); 
    Q = 0;vv = 0;
end

Aj_ = A + alpha*(Q*Q');
muj_ = Aj_\(A*mu + alpha*(Q*vv));

r = mvnrndpre(muj_, Aj_);

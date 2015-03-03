% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [Us Vs rmseTe] = BPMF(CTr, CTe, D, alpha, hyper_params, init, options)
%[Us Vs] = BPMF(CTr, CTe, D, alpha, hyper_params, init,
%max_iter, n_sample, run_name)
% bayesian probabilistic matrix factorization
% CTr: training contingency table
% CTe: testing contingency table
% D: feature dimension
% alpha: observation precision
% hyper_params: hyper parameters: (mu, muT, nu, beta, W, WT)
% init: initalization value: (U, V, T).  if a scalar, then
% the sampling will start from the existing sample. The sample
% number will follow the given sample, which will overwrite the
% original subsequent ones.
% max_iter: maximum number of samples to draw
% n_sample: # samples used to calculate the result. if <= 0, then
% samples will be output to files
% Us, Vs: factor samples. each column is a sample. need reshape before use.

if nargin < 7; options = []; end
[max_iter save_sample n_sample, run_name] = GetOptions(options,...
    'max_iter',50,'save_sample',false,'n_sample',50,'run_name','');

if save_sample
    sample_file_format = GetSampleFileFormat('m');
end

[M N] = size(CTr);

%priors
[mu0 nu0 beta0 W0] = GetOptions(hyper_params, ...
    'mu',0,'nu',D,'beta',1,'W',eye(D));
iW0 = inv(W0);

%tensor data
subs = CTr.subs;
assert(all(min(subs) >= 1));
assert(all(max(subs) <= [M N]));
vals = CTr.vals;
L = length(vals);
clear CTr;

fprintf('Bayesian PMF for matrix (%d, %d):%d. D = %d.\n', M, N, L, D);
fprintf('alpha=%g, mu=%g, nu=%g, beta=%g, W=%g\n', ...
        alpha, mu0(1), nu0, beta0, W0(1,1));

fprintf('Initialization...');
sample_idx = 1;
if isempty(init)
    U = randn(D, M)*0.1;
    V = randn(D, N)*0.1;
elseif iscell(init)
    [U V] = cell2vars(init);clear init;
    assert(size(U, 1) == D);
else
    assert(save_sample);
    fprintf('Continue from sample %d...', init);U=[];V=[];
    load(sprintf(sample_file_format, run_name, D, init));
    sample_idx = init + 1;
    
    assert(n_sample<=0, 'can only generate sample when start from samples');
    assert(all(size(U)==[D M]));
    assert(all(size(V)==[D N]));
end

te = ~isempty(CTe);

if te
    subsTe = CTe.subs;
    valsTe = CTe.vals;
    LTe = length(valsTe);
    clear CTe;
end

rmseTe = nan;
yTr = PMF_Reconstruct(subs, U, V);
rmseTr = RMSE(yTr - vals);
if te
    yTe = PMF_Reconstruct(subsTe, U, V);
    rmseTe = RMSE(yTe - valsTe);
end

fprintf('complete. RMSE=%0.4f/%0.4f.\n', rmseTr, rmseTe);

%sample buffer
if n_sample > 0
    ysTr = zeros(L, n_sample);
    if te
        ysTe = zeros(LTe, n_sample);
    end
    Us = zeros(D*M, n_sample);
    Vs = zeros(D*N, n_sample);
end

fprintf('Pre-calculating the index...');
subU = subs(:, 1);
subV = subs(:, 2);
fprintf('U');subU_bag = GroupIndex(subU, M);
fprintf('V');subV_bag = GroupIndex(subV, N);
subVU_bag = cell(1, M);
valsU_bag = cell(1, M);
for ind = 1:M
    subVU_bag{ind} = subV(subU_bag{ind});
    valsU_bag{ind} = vals(subU_bag{ind});
end
subUV_bag = cell(1, N);
valsV_bag = cell(1, N);
for ind = 1:N
    subUV_bag{ind} = subU(subV_bag{ind});
    valsV_bag{ind} = vals(subV_bag{ind});
end
clear subU subV subU_bag subV_bag
fprintf('. complete.\n');

if save_sample
    save(sprintf(sample_file_format, run_name, D, sample_idx - 1), 'U', 'V');
end

tic;
for iter = sample_idx:(sample_idx + max_iter - 1)
    fprintf('-Iter = %d... ', iter);
    
    %sample the prior of U
    Umean = mean(U, 2);
    beta0_ = beta0 + M;
    mu0_ = (beta0*mu0 + M*Umean)/beta0_;
    nu0_ = nu0 + M;
    dMu = mu0 - Umean;
    S = U*U' - M*(Umean*Umean');
    iW0_ = iW0 + S + (beta0*M/beta0_)*(dMu*dMu');
    
    W0_ = inv(iW0_);
    W0_ = (W0_ + W0_')*0.5;
    A_U = wishrnd(W0_, nu0_);
    mu_U = mvnrndpre(mu0_, beta0_*A_U);
    
    %sample the prior of V
    Vmean = mean(V, 2);
    beta0_ = beta0 + N;
    mu0_ = (beta0*mu0 + N*Vmean)/beta0_;
    nu0_ = nu0 + N;
    dMu = mu0 - Vmean;
    S = V*V' - N*(Vmean*Vmean');
    iW0_ = iW0 + S + (beta0*N/beta0_)*(dMu*dMu');
    
    W0_ = inv(iW0_);
    W0_ = (W0_ + W0_')*0.5;
    A_V = wishrnd(W0_, nu0_);
    mu_V = mvnrndpre(mu0_, beta0_*A_V);
    
    fprintf('U');
    parfor ind = 1:M
        U(:, ind) = UpdateFactor(alpha, A_U, mu_U, ...
            V(:, subVU_bag{ind}), valsU_bag{ind});
    end
    
    fprintf('V');
    parfor jnd = 1:N
        V(:, jnd) = UpdateFactor(alpha, A_V, mu_V, ...
            U(:, subUV_bag{jnd}), valsV_bag{jnd});
    end
    
    if save_sample
        save(sprintf(sample_file_format, run_name, D, iter), ...
            'U','V','A_U','mu_U', 'A_V', 'mu_V');
    end
    
    %record samples
    count = mod(iter - 1, n_sample) + 1;
    Us(:, count) = U(:);
    Vs(:, count) = V(:);
    
    % current performance
    ysTr(:, count) = PMF_Reconstruct(subs, U, V);
    yTr = mean(ysTr(:, 1:min(iter, n_sample)), 2);
    rmseTr = RMSE(yTr - vals);
    
    rmseTe = nan;
    if te
        ysTe(:, count) = PMF_Reconstruct(subsTe, U, V);
        yTe = mean(ysTe(:, 1:min(iter, n_sample)), 2);
        rmseTe = RMSE(yTe - valsTe);
    end
    
    fprintf(' Using last %d samples. RMSE=%0.4f/%0.4f. ETA=%0.2fhr\n', ...
        min(iter, n_sample), rmseTr, rmseTe, ...
        (max_iter + sample_idx - 1 - iter)*toc/(iter - sample_idx + 1)/3600);
end

function [r] = UpdateFactor(alpha, A, mu, ff, vv)

if isempty(vv);
    ff = 0;vv = 0;
end

Aj_ = A + alpha*(ff*ff');
muj_ = Aj_\(A*mu + alpha*(ff*vv));

r = mvnrndpre(muj_, Aj_);

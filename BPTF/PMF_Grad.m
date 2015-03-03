% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [U, V, obj, rmseTe] = PMF_Grad(C, CTe, init, options)
% PMF /w raw gradient descent

if nargin < 4; options = []; end
[ridge, learn_rate, range, max_iter] = GetOptions(options,...
    'ridge',1e-3, 'learn_rate',1e-3, 'range',[], 'max_iter',100);

M = C.size(1);
N = C.size(2);
subs = C.subs;
vals = C.vals;
L = length(vals);
clear C;

fprintf('Initialization...');
if numel(init) == 1
    D = init;
    U = rand(D, M)*1e-2;
    V = rand(D, N)*1e-2;
else
    [U V] = cell2vars(init);
    D = size(U, 1);clear init;
end

tr = false;
te = ~isempty(CTe);
if te
    subsTe = CTe.subs;
    valsTe = CTe.vals;
    clear CTe;
end

rmseTr = nan;
rmseTe = nan;
if tr
    yTr = PMF_Reconstruct(subs, U, V);
    rmseTr = RMSE(yTr - vals);
end
if te
    yTe = PMF_Reconstruct(subsTe, U, V);
    rmseTe = RMSE(yTe - valsTe);
end
fprintf('complete. RMSE=%0.4f/%0.4f.\n', rmseTr, rmseTe);

fprintf(['Start PMF with D=%d, Ridge=%g, LearnRate=%g\nData=(%d, ' ...
    '%d): %d\n'], D, ridge, learn_rate, M, N, L);
tic;
rmse = nan(max_iter, 1);
for iter = 1:max_iter
    [U, V] = PMF_Grad_Unit(subs, vals, U, V, learn_rate, ridge, 1, L);
    
    if mod(iter - 1, 10) ~= 0 && iter ~= max_iter
        continue;
    end
        
    fprintf('-Iter=%d/%d... ', iter, max_iter);
    if tr
        yTr = PMF_Reconstruct(subs, U, V);
        res = vals - yTr;
        obj = 0.5*(sum(res.^2) + ridge*sum(U(:).^2) + ridge*sum(V(:).^2));
        rmseTr = RMSE(res);
    else
        obj = nan;
        rmseTr = nan;
    end
    
    if te
        yTe = PMF_Reconstruct(subsTe, U, V);
        if ~isempty(range)
            yTe = max(min(yTe, max(range)), min(range));
        end
        rmseTe = RMSE(yTe - valsTe);
    else
        rmseTe=nan;
    end
    
    fprintf('Obj=%0.1f, RMSE=%0.4f/%0.4f. ETA=%0.1f hrs.\n', ...
        obj, rmseTr, rmseTe, (max_iter - iter)*toc/iter/3600);
    
    rmse(iter) = rmseTe;
    if (iter > 3 && all(diff(rmse((iter - 3):iter)) > 0))
        break;
    end
end

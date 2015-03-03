% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

build;

cd ./lib
build;
cd ..
addpath ./lib

load TTr
load TTe
TTr = spTensor(TTr.subs, TTr.vals, TTr.size);
TTe = spTensor(TTe.subs, TTe.vals, TTe.size);
CTr = TTr.Reduce(1:2);
CTe = TTe.Reduce(1:2);

D = 30;

pn = 50e-3;
max_iter = 300;
learn_rate = 1e-3;
n_sample = 50;

[U, V, dummy, r_pmf] = PMF_Grad(CTr, CTe, D, ...
    struct('ridge',pn,'learn_rate',learn_rate,'range',[1,5],'max_iter',max_iter));
fprintf('PMF: %.4f\n', r_pmf);

alpha = 2;
[Us_bpmf, Vs_bpmf] = BPMF(CTr, CTe, D, alpha, [], {U,V}, ...
    struct('max_iter',n_sample,'n_sample',n_sample,'save_sample',false, 'run_name','alpha2'));
[Y_bpmf] = BPMF_Predict(Us_bpmf, Vs_bpmf, D, CTe, [1 5]);
r_bpmf = RMSE(Y_bpmf.vals - CTe.vals);
fprintf('BPMF: %.4f\n', r_bpmf);

[Us_bptf Vs_bptf Ts_bptf] = BPTF(TTr, TTe, D, struct('Walpha',alpha, 'nuAlpha',1), ...
    {U,V,ones(D,TTr.size(3))}, struct('max_iter',n_sample,'n_sample',n_sample,'save_sample',false,'run_name','alpha2-1'));
[Y_bptf] = BPTF_Predict(Us_bptf,Vs_bptf,Ts_bptf,D,TTe,[1 5]);
r_bptf = RMSE(Y_bptf.vals-TTe.vals);
fprintf('BPTF: %.4f\n', r_bptf);

r = [r_pmf r_bpmf r_bptf]

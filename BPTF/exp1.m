clc;

% build;
% cd ./lib
% build;
% cd ..
% addpath ./lib

train = [1 4 0;
    3 0 5;
    1 3 4
    0 5 0];
test = [1 4 1;
    3 4 5;
    1 3 4
    3 5 1];

rg = [1, 5];
n_sample = 3;
D = size(train,2);

TTr = initDataset(train, [0]);
TTe = initDataset(test, [0]);

TTr = spTensor(TTr.subs, TTr.vals, TTr.size);
CTr = TTr.Reduce(1:2);

TTe = spTensor(TTe.subs, TTe.vals, TTe.size);
CTe = TTe.Reduce(1:2);

pn = 50e-3;
max_iter = 300;
learn_rate = 1e-3;

[U, V, ~, r_pmf] = PMF_Grad(CTr, CTe, D, ...
    struct('ridge',pn,'learn_rate',learn_rate,'range',rg,'max_iter',max_iter));
fprintf('PMF: %.4f\n', r_pmf);

alpha = 2;
[Us_bpmf, Vs_bpmf] = BPMF(CTr, CTe, D, alpha, [], {U,V}, ...
    struct('max_iter',n_sample,'n_sample',n_sample,'save_sample',false, 'run_name','alpha2'));
[Y_bpmf] = BPMF_Predict(Us_bpmf, Vs_bpmf, D, CTe, rg);
r_bpmf = RMSE(Y_bpmf.vals - CTe.vals);
fprintf('BPMF: %.4f\n', r_bpmf);

r = [r_pmf r_bpmf]
return;

[Us_bptf Vs_bptf Ts_bptf] = BPTF(TTr, TTe, D, struct('Walpha',alpha, 'nuAlpha',1), ...
    {U,V,ones(D,TTr.size(3))}, struct('max_iter',n_sample,'n_sample',n_sample,'save_sample',false,'run_name','alpha2-1'));
[Y_bptf] = BPTF_Predict(Us_bptf,Vs_bptf,Ts_bptf,D,TTe,rg);
r_bptf = RMSE(Y_bptf.vals-TTe.vals);
fprintf('BPTF: %.4f\n', r_bptf);

r = [r_pmf r_bpmf r_bptf]

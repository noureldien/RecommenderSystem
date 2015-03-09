% testing cool stuff

[M,N] = size(data);
vals = Y_bpmf.vals;
estm = reshape(vals,[M, N]);

offset = size(data,1) + 1 - size(test,1);
estm =  estm(offset:end,:);
saveResult(test, estm, 47);
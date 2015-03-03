% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [Y U V rmse] = BPMF_Predict(Us, Vs, D, C, range)
% apply the result of BPMF to testing data
%Us: U samples
%Vs: V samples
%D: factor dimension
%C: test matrix. if C is empty, then the full matrix is reconstructed
%range: output range of the prediction

n_sample = size(Us, 2);
[M N] = size(C);
subs = C.subs;
vals = C.vals;
clear C;

Y = zeros(length(vals), 1);
for ind = 1:n_sample
    U = reshape(Us(:,ind),D,M);
    V = reshape(Vs(:,ind),D,N);
    Y = Y + PMF_Reconstruct(subs, U, V);
end
Y = Y./n_sample;
if ~isempty(range)
    Y = max(min(Y, max(range)), min(range));
end

rmse = RMSE(Y - vals);
Y = spTensor(subs, Y, [M,N]);
U = reshape(mean(Us, 2), D, M);
V = reshape(mean(Vs, 2), D, N);

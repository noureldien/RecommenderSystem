% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [Y U V T rmse] = BPTF_Predict(Us, Vs, Ts, D, TTe, range)
%[Y] = BPTF_Predict(Us, Vs, Ts, D, TTe, range)
% apply the result of BPTF to testing data
%Us: U samples
%Vs: V samples
%Ts: T samples
%D: factor dimension
%TTe: test tensor. if TTe is a scalar, then the slice at time step TTe is fully reconstructed.
%range: output range of the prediction

n_sample=size(Us, 2);
[M N K] = size(TTe);

subs = TTe.subs;
vals = TTe.vals(:);
L = length(vals);
Y = zeros(L, 1);
for ind = 1:n_sample
    U = reshape(Us(:, ind), D, M);
    V = reshape(Vs(:, ind), D, N);
    T = reshape(Ts(:, ind), D, K);
    y = PTF_Reconstruct(subs, U, V, T);
    Y = Y + y;
end
Y = Y/n_sample;
if ~isempty(range)
    Y = max(min(Y, max(range)), min(range));
end

rmse = RMSE(Y - vals);
Y = spTensor(subs, Y, TTe.size);
U = reshape(mean(Us, 2), D, M);
V = reshape(mean(Vs, 2), D, N);
T = reshape(mean(Ts, 2), D, K);

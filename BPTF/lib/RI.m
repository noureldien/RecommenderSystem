% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [idx] = RI(n, max_idx, replace, sorted)
%[idx] = RI(n, max_idx, replace, sorted)
%get some random index
%n: number of index to select
%max_idx: numel of the array, or the arry itself.
%replace: sampling with replacement. default false
%sorted: sort the indeces or not. default false

if nargin < 4
    sorted = false;
    if nargin < 3
        replace = false;
    end
end

if ~replace && n > 1
    idx = randperm(max_idx);
    idx = idx(1:min(n,numel(idx)))';
else
    idx = floor(rand(n,1)*max_idx) + 1;
end

if sorted
    idx = sort(idx);
end

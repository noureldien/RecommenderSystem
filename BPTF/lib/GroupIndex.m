% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [gI]=GroupIndex(I, n)
%[gI]=GroupIndex(I, n)
% group the index I into cell array.
% I: index. should contain index from 1 to n.
% gI: grouped index. cell array. gI{ind} contains the positions in
% I that ind appears.

if nargin < 2
    n = max(I);
end
gI = accumarray(I(:), 1:length(I), [n, 1], @(x){x});

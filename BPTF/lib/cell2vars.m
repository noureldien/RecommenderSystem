% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [varargout] = cell2vars(c, idx)

if nargin < 2
    idx = 1:length(c);
end

varargout = cell(1, nargout);

if length(idx) < length(varargout)
    error('too many output');
end

for ind = 1:length(varargout)
    varargout{ind} = c{idx(ind)};
end

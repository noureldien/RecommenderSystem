% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [x, src] = mvnrndpre(mu, L, n)
% generate samples of norm variables with mean mu and precision L
% fast version of mvnrnd

if nargin < 3
    n = 1;
end

src = randn(length(mu), n);
x = bsxfun(@plus, linsolve(chol(L), src, struct('UT', true)), mu);

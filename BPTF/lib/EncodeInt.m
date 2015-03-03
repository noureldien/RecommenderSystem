% (C) Copyright 2011, Liang Xiong (lxiong[at]cs[dot]cmu[dot]edu)
% 
% This piece of software is free for research purposes. 
% We hope it is helpful but do not privide any warranty.
% If you encountered any problems please contact the author.

function [r]=EncodeInt(input, codebook, vals)
%function [r]=EncodeInt(input, codebook, vals)
%r(i)=val(codebook==input(i))
%keys and map should be both of type int32 or int64

if nargin < 2
    codebook = unique(input);
end

if nargin < 3
    vals = [];
else
    assert(length(codebook) == length(vals), ...
        'codebook and vals should be of same length');
end

if isa(input, 'int32') && isa(codebook, 'int32')
    index = EncodeInt32Array(input, codebook);
else
    if isa(input, 'int64') && isa(input, 'int64')
        index = EncodeInt64Array(input, codebook);
    else
        error('can not handle this type');
    end
end

if isempty(vals)
    r = reshape(index, size(input));
    return;
end

unfound = index == 0;
index(unfound) = 1;
r = vals(index);

if iscell(r)
    unfound = find(unfound);
    for ind = 1:length(unfound)
        r{unfound(ind)}='NA';
    end
else
    r(unfound)=0;
end

r = reshape(r, size(input));

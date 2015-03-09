function [sData] = initDataset(data, missings)

% create structure from the given data
%
% INPUT:
%
% OUTPUT:
%
%


% first, we have to extract the data without missings
[M,N] = size(data);
nMissings = length(missings);
indeces = 1:(M*N);
if (nMissings > 0)
    for i=1:length(missings)
        idx = find(data ~= missings(i));
        indeces = intersect(indeces, idx);
    end
end

% size is the number of users and features
sz = [M, N, 1];

% user id and feature id (only for complete ratings)
[idxI, idxJ] = ind2sub([M,N], indeces);
subs = ones(length(idxI),1);
if (nMissings>0)
    subs = [idxI, idxJ, subs];
else
    subs = [idxI', idxJ', subs];
end

% values are the ratings for all users (only the complete ratings)
if (nMissings>0)
    values = data(indeces);
else
    values = data(indeces)';
end


% finally, create the structure
sData = struct('subs', subs, 'vals', values, 'size', sz);

end
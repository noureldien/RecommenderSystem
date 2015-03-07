function [ recoveredData ] = dimensionRecovery( data, indeces )

% recover the feautures to the given data upon the given
% clusters of features
%
% INPUT:
%           data : M*N, where M observations, N features
%        indeces : array telling which feature is assigned to which cluster
%
% OUTPUT:
%  recoveredData : data after replacing the correlated features
%                  with thier mean values

[M,~] = size(data);
N = length(indeces);
nCluster = size(unique(nonzeros(indeces)),1);

% create the new data
recoveredData = zeros(M, N);
for i=1:nCluster
    idx = find(indeces==i);
    for j=1:length(idx)
        recoveredData(:,idx(j)) = data(:,i);
    end    
end

end

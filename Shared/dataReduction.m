function [ reducedData ] = dataReduction( data, clusters )

% reduce the features in the given data upon the given
% clusters of features

% input:
%           data : M*N, where M observations, N features
%       clusters : list of clustered features upon which to reduce the
%                  data

% output:
%    reducedData : data after replacing the correlated features
%                  with thier mean values

[M,N] = size(data);

% create the new data
nCluster = size(clusters,1);
reducedData = zeros(M, nCluster);
for i=1:nCluster
    idx = clusters{i,:};
    reducedData(:,i) = mean(data(:, idx),2);
end

end


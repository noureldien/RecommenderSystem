function [ recoveredData ] = dataRecovery( data, clusters, nFeatures )

% recover the feautures to the given data upon the given
% clusters of features

% input:
%           data : M*N, where M observations, N features
%       clusters : list of clustered features upon which to recover the
%                  data

% output:
%  recoveredData : data after replacing the correlated features
%                  with thier mean values

[M,~] = size(data);
N = nFeatures;
nCluster = size(clusters,1);

% create the new data
recoveredData = zeros(M, N);
for i=1:nCluster
    idx = clusters{i,:};
    for j=1:length(idx)
        recoveredData(:,idx(j)) = data(:,i);
    end    
end

end

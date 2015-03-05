function [ clusters ] = featureSelection( data, errorThreshold, varThreshold, missings )

% group features into clusters, each cluster has a group
% of similar features, where the rmse between any pair of features
% in one cluster is less than or equal to the given threshold
%
% input:
%         data      : M*N, where M observations, N features
%    errorThreshold : over this threshold, the 2 features are not considered correlated
%      varThreshold : a feature with variance over it is considered noisy and not picked up in the cluster
%
% output:
%          clusters : list of clustered features


K = length(missings);
[M,N] = size(data);

% replace missings with zero
for j=1:K
    data(data == missings(j)) = 0;
end

% get matrix that represent the pair-wise rmse
% between the features
errors = zeros(N,N);
for i=1:N
    for j=i:N
        f1 = data(:,i);
        f2 = data(:,j);
        error = sqrt(mean((f1-f2).^2));
        errors(i,j) = error;
        errors(j,i) = error;
    end
end

% get the variances of the feature, at the end of the algorithm
% a feature is not clustered, check it's variance, if it has
% hight variance, then it's a noisy feature, neglect it
% on the other hand, if it has low variance, then it's a good
% discrimanent feature, add it to it's own cluster
vars = dataVariances(data, [55 99]);

% represents the clusters of correlated features
% each row represnet a cluster, which contains
% the index of correlated features
clusters = {};

% loop on the coeffs of the features
for i=1:N
    
    isCorrelated = false;
    
    % loop on the clusters of features
    for j=1:size(clusters,1)
        
        % loop each the features in the current cluster
        for k=1:size(clusters,2)
            
            % the id of the feature in the current cluster
            clusteredFeatureID = clusters{j,k};
            
             % check the error between the current feature
            % and the clustered feature is below threshold
            isCorrelated = errors(clusteredFeatureID,i) <= errorThreshold;
            
            % if only one clustered feature is not correlated
            % with the current feature, then the current feature
            % is not correlated with all the cluster
            if (~isCorrelated)
                break;
            end
        end
        
        % break if correlation is found
        if (isCorrelated)
            break;
        end
        
    end
    
    % now, if there is correlation
    % then add the feature to the cluster
    if (isCorrelated)
        clusters{j,:} = [clusters{j,:} i];
    else
        % if no correlation is found, then check if
        % the feature is noisy or not, by checking it's variance
        % if it is noisy, then add it in a new cluster
        if (vars(i) <= varThreshold)
            clusters = [clusters; i];
        end
    end
    
end

end


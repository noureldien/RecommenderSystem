function [ clusters, indeces ] = observSelection( data, errorThreshold, varThreshold, missings )

% group users/observations into clusters, each cluster has a group
% of similar users. a cluster called user pattern
% the rmse between any pair of features
% in one cluster is less than or equal to the given threshold
%
% input:
%         data      : M*N, where M observations, N features
%    errorThreshold : over this threshold, the 2 users are not considered correlated
%      varThreshold : a feature with variance over it is considered noisy and not picked up in the cluster
%
% output:
%          clusters : list of users features (user patterns)


K = length(missings);
[M,N] = size(data);

% get matrix that represent the pair-wise rmse
% between the features
errors = zeros(M,M);
for i=1:M
    for j=i:M
        if (i==j)
            error = 0;
        else            
            % check if no missing data, then get all features
            % of the user. if missing data, get only
            % the common features with no missing data
            if (K == 0)
                u1 = data(i,:);
                u2 = data(j,:);
            else
                idx1 = [];
                idx2 = [];
                for k=1:K
                    idx1 = [idx1; find(data(i,:) ~= missings(k))];
                    idx2 = [idx2; find(data(j,:) ~= missings(k))];
                end
                idx = intersect(idx1, idx2);
                u1 = data(i,idx);
                u2 = data(j,idx);
            end
            error = sqrt(mean((u1-u2).^2));
        end        
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

% also save your choices in a matrix
indeces = [];

% loop on the coeffs of the users
for i=1:M
    
    isCorrelated = false;
    
    % loop on the clusters of users
    for j=1:size(clusters,1)
        
        % loop on each user in the current cluster
        for k=1:size(clusters,2)
            
            % the id of the user in the current cluster
            clusteredUserID = clusters{j,k};
            
            % check the error between the current user
            % and the clustered user is below threshold
            isCorrelated = errors(clusteredUserID,i) <= errorThreshold;
            
            % if only one clustered user is not correlated
            % with the current user, then the current user
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
    % then add the user to the cluster
    if (isCorrelated)
        clusters{j,:} = [clusters{j,:} i];
        indeces = [indeces; [i, j]];
    else
        % if no correlation is found, then check if
        % the user is noisy or not, by checking it's variance
        % if it is noisy, then add it in a new cluster
        if (vars(i) <= varThreshold)
            clusters = [clusters; i];
            indeces = [indeces; [i, size(clusters,1)]];
        end
    end
    
end

end
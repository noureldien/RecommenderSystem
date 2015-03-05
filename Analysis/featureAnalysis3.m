% this is some analysis done over the features
% using distance between features (as if a feature is a vector)
% using the distance or rmse is the same

% a distance metric can be eucledian
% mahanobolis is not required becuase all features are normalized
% i.e. a feature has values from -10 to 10

% this analysis is very similiar to 'featureAnalysis2' expect
% the later is using correlation-coeff instead of e pair-wise distances
% between features

%% the algorithm

clc;

% include directories
addpath(genpath('..\Data\'));
addpath(genpath('..\Shared\'));

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');
% load('..\Data\fourk.mat');
% load('..\Data\fourk55.mat');
% load('..\Data\train.mat');
% load('..\Data\test.mat');

data = t_truth;
[M,N] = size(data);

% get matrix that represent the pair-wise rmse/distance
% between the features
errors = zeros(N,N);
distances = zeros(N,N);
for i=1:N
    for j=i:N
        f1 = data(:,i);
        f2 = data(:,j);
        error = f1-f2;
        distance = norm(error);
        error = sqrt(mean((error).^2));
        distances(i,j) = distance;
        distances(j,i) = distance;
        errors(i,j) = error;
        errors(j,i) = error;
    end
end

% get the variances of the feature, at the end of the algorithm
% a feature is not clustered, check it's variance, if it has
% hight variance, then it's a noisy feature, neglect it
% on the other hand, if it has low variance, then it's a good
% discrimanent feature, add it to it's own cluster
vars = dataVariances(data, [99 55]);

% over this threshold, the 2 features are not considered correlated
errorThreshold = 5.7;
distanceThreshold = 455;

% use distance as a proof of correlation instead or rmse
useDistance = true;

% variance threshold, a feature with variance over it
% is considered noisy and not picked up in the cluster
varThreshold = 33;

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
            % 2 different measuring system can be used
            if (useDistance)
                isCorrelated = distances(clusteredFeatureID,i) <= distanceThreshold;
            else
                isCorrelated = errors(clusteredFeatureID,i) <= errorThreshold;
            end
            
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

%% visualizing the clustered (correlated) features
% % 2,16,75
% % 11,12,14
% f1 = data(:,12);
% f2 = data(:,14);
%
% histos = featuresHistogram([f1 f2], [55 99]);
% rates = -10:10;
%
% figure(1);clf;
% fig = figure(1);clf;
% subplot(2,2,1);
% axis([0 500 -10 10]);
% hold on;
% grid on;
% box on;
% barh(rates, histos(1,:));
% subplot(2,2,2);
% axis([0 500 -10 10]);
% hold on;
% grid on;
% box on;
% barh(rates, histos(2,:));
% subplot(2,2,3);
% hold on;
% grid on;
% box on;
% plot(f1, f2, '.');
% f1_ = sort(f1);
% f2_ = sort(f2);
% plot(f1_, f2_, '.r');
% disp(sqrt(mean((f1-f2).^2)));












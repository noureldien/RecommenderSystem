clc;

% measure rmse for feature selection

load('Data\t_truth.mat');
load('Data\t_test.mat');
load('Data\t_train.mat');

[M,N] = size(t_truth);

% do feature reduction/selection
varianceThreshold = 33;
errorThreshold = 5.6;
clusters = featureSelection(t_truth, errorThreshold, varianceThreshold, [99]);
t_truthReducted = dataReduction(t_truth, clusters, []);

% sainitize the train before handling it to the 
%t_test_ = t_test;
%train_(train_==99) = 0;

% now, after the 
K = size(clusters,1);
[kmIdxTrain, kmCTrain] = kmeans(t_truth', K);
kmCTrain = kmCTrain';

% after clustering the users using k-means and feature-selection
% check their performance by measuring how the centers of the clusters
% deviate form the features they represent deviated

% measure rmse for k-means
rmse = zeros(1,N);
for i=1:N
    idx = kmIdxTrain(i);
    rmse(i) = sqrt(mean((t_truth(:,i) - kmCTrain(:,idx)).^2));
end
rmse_Kmean = mean(rmse);

% measure rmse for featureClustering
rmse = [];
nClusters = size(clusters,1);
for i=1:nClusters;
    cluster = clusters{i,:};
    for j=1:length(cluster)        
        idx = cluster(j);
        rmse = [rmse sqrt(mean((t_truth(:,idx) - t_truthReducted(:,i)).^2))];
    end    
end
rmse_featSelect = mean(rmse);








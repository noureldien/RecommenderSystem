% putting the developed algorithm 'featureSeletion' to test
% measuring it against k-means using t_truth data
% becuase t_trurth is complete and more fair to k-means

% conclusion, after doing the testing below, I found that
% 'featureSelection' gives better results than 'k-means'
% not to mention that 'featureSelection' can deal with missing
% data while 'k-means' can't

clc;

load('Data\t_truth.mat');
load('Data\t_test.mat');

t_truth = t_test;
t_truth(t_truth == 99) = 0.00099;

[M,N] = size(t_truth);

% do feature reduction/selection
% hight value of variance threshold to guarantee none of
% the features get eliminated by variance threshold
varianceThreshold = 50;
errorThreshold = 5.6;
[indeces, K] = dimensionSelection(t_truth, errorThreshold, varianceThreshold, []);
t_truthReducted = dimensionReduction(t_truth, indeces, []);

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
for i=1:K
    idx = find(indeces==i);
    for j=1:length(idx)
        rmse = [rmse sqrt(mean((t_truth(:,idx(j)) - t_truthReducted(:,i)).^2))];
    end    
end
rmse_featSelect = mean(rmse);

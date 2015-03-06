clc;

% measure rmse for feature selection

load('Data\t_truth.mat');
load('Data\t_test.mat');
load('Data\t_train.mat');

[~,N] = size(t_train);

% do feature reduction/selection
varianceThreshold = 33;
errorThreshold = 5.6;
[fClusters, fIdx] = featureSelection(t_train, errorThreshold, varianceThreshold, [99]);

% train-Feature-Reducted
t_trainFRed = featureReduction(t_train, fClusters, [99]);

% reduce the test set using the same cluster
t_testFRed = featureReduction(t_test, fClusters, [99]);

disp('Done Feature Reduction');

% how many reducted features we have
nRed = length(fClusters);

% how many patterns of bservations we want to have
[M, ~] = size(t_train);
K = int16(M/10);

% sanitize the train before passing it to k-means
% this is to hide the 99, 55
% train-feature-reducted-and-sanitized
t_trainFRedSa = t_trainFRed;
t_trainFRedSa(t_trainFRedSa==99) = 0.00099;

% cluster the users to K cluster, don't use k-means
% as it will take forever
%[t_trainKmIdx, t_trainKmCenters] = kmeans(t_trainFRedSa, K);
%t_trainKmCenters = t_trainKmCenters';
[uClusters, uIdx] = featureSelection(t_train', errorThreshold, varianceThreshold, [99]);

disp('Done User Clustering');
return;

% restore the 99
t_trainKmCenters(t_trainKmCenters==0.00099) = 99;

% after clustering the users into patterns of users
% match each user in the training set with the pattern
% then predict the missing values
estmTest =  observPrediction(t_trainKmCenters, t_testFRed, [99], [99]);

disp('Done Predicting the missing');

% after matching and prediction
% recover the test data and see the error against the truth
estmTestRecov = dataRecovery(estmTest, fClusters,N);

% get the errors
[confusionEstm, rmseEstm, ameEstm] = calcError(t_truth, t_test, estmTestRecov, [99]);
disp(rmseEstm);







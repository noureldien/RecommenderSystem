clc;

% load data
load('Data\t_truth.mat');
load('Data\t_test.mat');
load('Data\t_train.mat');

[~,N] = size(t_train);

% do feature reduction/selection
varianceThr = 33;
errorThr = 5.6;
fIdx = dimensionSelection(t_train, errorThr, varianceThr, [99]);

% train-Feature-Reducted
t_trainFRed = dimensionReduction(t_train, fIdx, [99]);

% reduce the test set using the same cluster
t_testFRed = dimensionReduction(t_test, fIdx, [99]);

disp('Done Feature Reduction');

% how many reducted features we have
nFReducted = size(unique(nonzeros(fIdx)),1);

% cluster the users to K cluster
varianceThr = 33;
errorThr = 5.6;
uIdx = dimensionSelection(t_trainFRed', errorThr, varianceThr, [99]);

tic
% train-Feature-Reducted-user-reducted
t_trainFRedURed = dimensionReduction(t_trainFRed', uIdx, [99]);
toc

disp('Done User Clustering');

% how many user patterns we have
nUClusted = size(unique(nonzeros(uIdx)),1);

return;

% after clustering the users into patterns of users
% match each user in the training set with the pattern
% then predict the missing values
estmTest = observPrediction(t_trainFRedURed, t_testFRed, [99], [99]);

disp('Done Predicting the missing');

% after matching and prediction
% recover the test data and see the error against the truth
estmTestRecov = dataRecovery(estmTest, fClusters,N);

% get the errors
[confusionEstm, rmseEstm, ameEstm] = calcError(t_truth, t_test, estmTestRecov, [99]);
disp(rmseEstm);







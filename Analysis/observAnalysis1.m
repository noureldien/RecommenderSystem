clc;

% this analysis is done to see if we reduced feature from training
% then cluster users (that already have reducted feature)
% then used the last matrix (reducted features) to predict 99 from the test matrix
% then use estimated matrix to do matrix completion and predict the 55

% load data
load('Data\t_truth.mat');
load('Data\t_test.mat');
load('Data\t_train.mat');

[~,N] = size(t_train);

% do feature reduction/selection
varianceThr = 33;
errorThr = 5.6;
[fIdx, nFReducted] = dimensionSelection(t_train, errorThr, varianceThr, [99]);

% train-Feature-Reducted
t_trainFRed = dimensionReduction(t_train, fIdx, [99]);

% reduce the test set using the same cluster
t_testFRed = dimensionReduction(t_test, fIdx, [99]);

disp('Done Feature Reduction');

% cluster the users to K cluster
% here is the trick about clustering the users, data of users is huge
% so if we took into consideration the 99, it will take more time
% plus it's not much of a difference (rmse) between replacing 99 with zero
% and using the very slow knn

% hide the 99
t_trainFRed_ = t_trainFRed;
t_trainFRed_(t_trainFRed_==99) = 0.00099;

varianceThr = 1000;
errorThr = 5.6; % this gives 635 users
tic
uIdx = dimensionSelection(t_trainFRed_', errorThr, varianceThr, []);
toc

% train-Feature-Reducted-user-reducted
t_trainFRedURed = dimensionReduction(t_trainFRed', uIdx, [99])';

disp('Done User Clustering');

% how many user patterns we have
nUClusted = size(unique(nonzeros(uIdx)),1);

% after clustering the users into patterns of users
% match each user in the training set with the pattern
% then predict the missing values
estmTest = dataPrediction(t_trainFRedURed, t_testFRed, [99], [99]);

disp('Done Predicting the missing');

% after matching and prediction
% recover the test data and see the error against the truth
estmTestRecov = dimensionRecovery(estmTest, fIdx);

% get the errors
[confusionEstm, rmseEstm, ameEstm] = calcError(t_truth, t_test, estmTestRecov, [99]);
disp(rmseEstm);







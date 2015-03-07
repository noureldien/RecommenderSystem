% this analysis is done to see if we reduced feature from training
% then cluster users (that already have reducted feature)
% then used the last matrix (reducted features) to predict 99 from the test matrix
% then use estimated matrix to do matrix completion and predict the 55

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');

[~,N] = size(train);

% do feature reduction/selection
varianceThr = 33;
errorThr = 5.6;
[fIdx, nFReducted] = dimensionSelection(train, errorThr, varianceThr, [99]);

% train-Feature-Reducted
t_trainFRed = dimensionReduction(train, fIdx, [99]);

% reduce the test set using the same cluster
t_testFRed = dimensionReduction(test, fIdx, [99 55]);

disp('Done Feature Reduction');

% cluster the users to K cluster
% here is the trick about clustering the users, data of users is huge
% so if we took into consideration the 99, it will take more time
% plus it's not much of a difference (rmse) between replacing 99 with zero
% and using the very slow knn

% hide the 99 in the training becuase clustering users
% with missing data takes forever, so let alone the missing
% data for now when clustering users
t_trainFRed_ = t_trainFRed;
t_trainFRed_(t_trainFRed_==99) = 0.00099;

varianceThr = 1000;
errorThr = 5.2;
tic
uIdx = dimensionSelection(t_trainFRed_', errorThr, varianceThr, []);
toc

% train-Feature-Reducted-user-reducted
t_trainFRedURed = dimensionReduction(t_trainFRed', uIdx, [99])';

% how many user patterns we have
nUClusted = size(unique(nonzeros(uIdx)),1);

disp('Done User Clustering');

% after clustering the users into patterns of users
% match each user in the training set with the pattern
% then predict the missing values
estmTest = dataPrediction(t_trainFRedURed, t_testFRed, [99], [99 55]);

disp('Done Predicting the missing');

% after matching and prediction
% recover the test data and see the error against the truth
estmTestRecov = dimensionRecovery(estmTest, fIdx);

% save the results
saveResult(test, estmTestRecov, 19);

disp('Done Saving Results');

% one step is using the estimated test, place 55 in it
% and estimate 55
test55 = estmTestRecov;
test55(test==55) = 55;
estmTest55 = dataCompletion(test55, [55]);

% save the results
saveResult(test, estmTestRecov, 20);










% try to do user reduction of train
% then use train+test to do prediction
% avoid feature reduction, because may be
% all features are important

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');

[~,N] = size(train);

t_train = train;
t_test = test;

% cluster the users to K cluster
% here is the trick about clustering the users, data of users is huge
% so if we took into consideration the 99, it will take more time
% plus it's not much of a difference (rmse) between replacing 99 with zero
% and using the very slow knn

% hide the 99 in the training becuase clustering users
% with missing data takes forever, so let alone the missing
% data for now when clustering users
t_train_ = t_train;
t_train_(t_train_==99) = 0.00099;

varianceThr = 1000;
errorThr = 5.2;
tic
uIdx = dimensionSelection(t_train_', errorThr, varianceThr, []);
toc

% train-user-reducted
t_trainURed = dimensionReduction(t_train', uIdx, [99])';

% how many user patterns we have
nUClusted = size(unique(nonzeros(uIdx)),1);

disp('Done User Clustering');

% after clustering the users into patterns of users
% match each user in the training set with the pattern
% then predict the missing values
estmTest = dataPrediction(t_trainURed, t_test, [99], [99 55]);

disp('Done Predicting the missing');

% save the results
saveResult(test, estmTest, 19);

disp('Done Saving Results');








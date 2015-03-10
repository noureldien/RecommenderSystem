% train to predict 99 in the train
% then use train along with train to predict 99, 55 in test
% then use test to predict 55 in test

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');

% estimate the training
estm =  dataCompletion(train, [99]);

% then use the estimated training to estimate 99, 55 of test
estm55 = dataPrediction(estm, test, [], [99 55]);

% save the results
saveResult(test, estm55, 27);

disp('Done Saving Results');










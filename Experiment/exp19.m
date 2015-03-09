% this is pretty much the same as exp15
% except after estimating the 55 for the test
% we go back and override the estimated 55 values
% for users with shitty variances
% users with low variance, but the estimate to their mean
% users with high varance, but the estimate to the feature mean

clc;

%% first step, do the estimation
% % load data
% load('Data\train.mat');
% load('Data\test.mat');
% load('Data\estm.mat');
% 
% data = [train; test];
% 
% % complete 99 using average and 55 using matrix completion
% estm99 = averageCompletion(data, [99]);
% 
% % instead of expensive computation, just
% % load from the data
% % estm = dataCompletion(estm99, [55]);


%% second step, improve the estimation

estmAdj = adjustObservPrediction(test, estm, estm99);

offset = size(estm99,1) + 1 - size(test,1);
test99_ = estm99(offset:end,:);

% save the results
saveResult(test, estmAdj, 38);








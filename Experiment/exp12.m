% t_truth+test to predict 99 in test
% then use test to predict 55 in test

clc;

% load data
load('Data\t_truth.mat');
load('Data\test.mat');

% estimate train + test
estm = dataPrediction(t_truth, test, [99], [99 55]);

% save the results
saveResult(test, estm, 21);

% one step is using the estimated test, place 55 in it
% and estimate 55
test55 = estm;
test55(test==55) = 55;
estm55 = dataCompletion(test55, [55]);

% save the results
saveResult(test, estm55, 22);

disp('Done Saving Results');










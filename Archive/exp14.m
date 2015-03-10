% in this experiment, instead of doing feature clustering
% we'd only get rid of bad users (depending on their rating variances)
% then use train+test to do prediction. avoid feature reduction,
% because may be all features are important

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');

[~,N] = size(train);

t_train = train;
t_test = test;


% train-bad-user-eliminated
varianceThr = 88;
t_trainURed = observationElimination(t_train, varianceThr, [99]);

% predict the missing values
estmTest = dataPrediction(t_trainURed, t_test, [99], [99 55]);

disp('Done Predicting the missing');

% save the results
saveResult(test, estmTest, 19);

disp('Done Saving Results');








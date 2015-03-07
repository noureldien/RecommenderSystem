% fill test with average, then do matrix
% completion using t_truth + test

clc;

% load data
load('Data\t_truth.mat');
load('Data\t_test.mat');
load('Data\t_test55.mat');
load('Data\fourk.mat');
load('Data\fourk55.mat');
load('Data\test.mat');

estm99 = averageCompletion([t_truth;t_test55], [99]);
estm saveResult(test, estm, 28);

return;


% fill test with average
estm1 = averageCompletion(t_test55,[55]);
estm2 = averageCompletion(t_test55,[99 55]);
estm3 = averageCompletion(estm2,[55]);

% get the errors
[~, rmseEstm, ~] = calcError(t_truth, t_test55, estm1, [55]);
disp(rmseEstm);

[~, rmseEstm, ~] = calcError(t_truth, t_test55, estm2, [99]);
disp(rmseEstm);

[~, rmseEstm, ~] = calcError(t_truth, t_test55, estm3, [55]);
disp(rmseEstm);

return;

% refill test with 55
estmTest(test==55) = 55;

% predict the missing values
estm = dataPrediction(t_truth, estmTest, [], [99 55]);

disp('Done Predicting the missing');

% save the results
saveResult(test, estmTest, 28);

disp('Done Saving Results');








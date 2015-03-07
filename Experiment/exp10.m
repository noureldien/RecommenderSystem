% in this experiment, we try to predict the 99 from test using
% matrix completion of t_truth+test then take the estimate and
% do matrix completion on it to predict the 55 from test

clc;

% load the data
load('Data\t_truth.mat');
load('Data\test.mat');

% predict the missing values
estm = dataPrediction(t_truth, test, [99] ,[99 55]);

data55 = estm;
data55(test==55) = 55;

% predict the missing values
estm55 = dataCompletion(data55, [55]);

% save the results
saveResult(test, estm55, 18);










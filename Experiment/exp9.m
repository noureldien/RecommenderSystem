% in this experiment, we try to predict the 99 from test using
% matrix completion of train+test then take the estimate and
% do matrix completion on it to predict the 55
% this experiment is done of fourk data

clc;

% load the data
load('Data\fourk.mat');
load('Data\fourk55.mat');

% the matrix is M x N
% m is the users, n is the jokes
data = fourk;

% predict the missing values
estm = dataCompletion(fourk55, [99 55]);

% this step (instead of the above) seems dump
% but it improved a little bit from 4.03 to 3.99
% may be the reason using the fourk+fourk55 in predicting fourk55
% helps in error regularization
%estm = dataPrediction(data, fourk55, [99] ,[99 55]);

data55 = estm;
data55(fourk55==55) = 55;

% predict the missing values
estm55 = dataCompletion(data55, [55]);

% get the errors
[~, rmseEstm, ~] = calcError(fourk, fourk55, estm55, [55]);
disp(rmseEstm);
% this was 4.02

% get the errors
[~, rmseEstm, ~] = calcError(fourk, fourk55, estm, [55]);
disp(rmseEstm);
% this was 3.99





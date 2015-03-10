% from now on, instead of experimenting on t*** dataset, user t_t***
% because we've ground truth for it (wich is t_truth)

% like experiment 15 except done on [t_train, t_test55]
% instead of [train, test]
% this experiment will be used as reference
% so, this one gave me rmse = 4.3423

clc;

% load data
load('Data\t_train.mat');
load('Data\t_truth.mat');
load('Data\t_test55.mat');

data = [t_train; t_test55];
estm99 = averageCompletion(data, [99]);
estm = dataCompletion(estm99, [55]);

offset = size(data,1) + 1 - size(t_test55,1);
estm =  estm(offset:end,:);

[~, rmse, ~] = calcError(t_truth, t_test55, estm,[55 99]);

% save the results
%saveResult(t_test55, estm, 32);








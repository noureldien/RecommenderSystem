% this experiment got me the 9th place up till now

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');

data = [train; test];
estm99 = averageCompletion(data, [99]);
estm = dataCompletion(estm99, [55]);

offset = size(data,1) + 1 - size(test,1);
estm =  estm(offset:end,:); 

% save the results
saveResult(test, estm, 32);








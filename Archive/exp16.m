% gave very close score to exp 15

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');

train99 = averageCompletion(train, [99]);
test99 = averageCompletion(test, [99]);

data = [train99;test99];
estm = dataCompletion(data, [55]);

offset = size(data,1) + 1 - size(test,1);
estm =  estm(offset:end,:);

% save the results
saveResult(test, estm, 32);





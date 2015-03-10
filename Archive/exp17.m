% usng user clustering
% it didn't pay off too much, but worth a re-visit
% rmse = 4.704

clc;

% load data
% load('Data\t_truth.mat');
% load('Data\t_test.mat');
% load('Data\t_test55.mat');
% load('Data\fourk.mat');
% load('Data\fourk55.mat');
load('Data\test.mat');
load('Data\train.mat');
load('Data\trainCluster.mat');
load('Data\trainClusterIdx.mat');

% cluster user
%varThr = 500;
%disThr = 65;
%[uIdx , ncluster] = observCluster(data', distances, disThr, varThr);
%trainCluster = dimensionReduction(data', uIdx, [])';

train99 = trainCluster;
test99 = averageCompletion(test, [99]);

data = [train99;test99];
estm = dataCompletion(data, [55]);

offset = size(data,1) + 1 - size(test,1);
estm =  estm(offset:end,:);

% save the results
saveResult(test, estm, 33);







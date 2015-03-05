clc;

% load the data
%load('.\Data\t_train.mat');
%load('.\Data\t_test.mat');
%load('.\Data\t_truth.mat');

% doing some analysis on feature using 
load ovariancancer;
whos

% controlling the generation of random numbers
rng(8000,'twister');

% holdout the data, i.e. dividing to train and test
holdoutCVP = cvpartition(grp,'holdout',56);
dataTrain = obs(holdoutCVP.training,:);
grpTrain = grp(holdoutCVP.training);

dataTrainG1 = dataTrain(grp2idx(grpTrain)==1,:);
dataTrainG2 = dataTrain(grp2idx(grpTrain)==2,:);
[h,p,ci,stat] = ttest2(dataTrainG1,dataTrainG2,'Vartype','unequal');

ecdf(p);
xlabel('P value');
ylabel('CDF value');













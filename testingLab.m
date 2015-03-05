clc;


% 6,61
% 9,67
% 12, 14, 26
% 4, 30, 33, 59
f1 = data(:,59);
f2 = data(:,33);

histos = featuresHistogram([f1 f2], [55 99]);
rates = -10:10;

figure(1);clf;
fig = figure(1);clf;
subplot(2,2,1);
axis([0 500 -10 10]);
hold on;
grid on;
box on;
barh(rates, histos(1,:));
subplot(2,2,2);
axis([0 500 -10 10]);
hold on;
grid on;
box on;
barh(rates, histos(2,:));
subplot(2,2,3);
hold on;
grid on;
box on;
plot(f1, f2, '.');
f1_ = sort(f1);
f2_ = sort(f2);
plot(f1_, f2_, '.r');
plot([-10 10], [-10 10], 'g', 'LineWidth', 2);
disp(sqrt(mean((f1-f2).^2)));

return;

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













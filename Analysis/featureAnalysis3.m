% this is some analysis done over the features
% using distance between features (as if a feature is a vector)
% using the distance or rmse is the same

% a distance metric can be eucledian
% mahanobolis is not required becuase all features are normalized
% i.e. a feature has values from -10 to 10

% this analysis is very similiar to 'featureAnalysis2' expect
% the later is using correlation-coeff instead of 
% pair-wise distance/rmse between features

%% visualizing the clustered (correlated) features
% f1 = data(:,59);
% f2 = data(:,33);
% histos = featuresHistogram([f1 f2], [55 99]);
% rates = -10:10;
% figure(1);clf;
% fig = figure(1);clf;
% subplot(2,2,1);
% axis([0 500 -10 10]);
% hold on;
% grid on;
% box on;
% barh(rates, histos(1,:));
% subplot(2,2,2);
% axis([0 500 -10 10]);
% hold on;
% grid on;
% box on;
% barh(rates, histos(2,:));
% subplot(2,2,3);
% hold on;
% grid on;
% box on;
% plot(f1, f2, '.');
% f1_ = sort(f1);
% f2_ = sort(f2);
% plot(f1_, f2_, '.r');
% plot([-10 10], [-10 10], 'g', 'LineWidth', 2);
% disp(sqrt(mean((f1-f2).^2)));

%% now it's time to put this hypothesis into action
% this is done by testing the prediction over fourk dataset

% first, we need to remove the features in each cluster
% and put instead of it the mean values for each feature

% include directories
addpath(genpath('.\Data\'));
addpath(genpath('.\Shared\'));

% load('..\Data\fourk.mat');
% load('..\Data\fourk55.mat');
% load('..\Data\train.mat');
% load('..\Data\test.mat');
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');

alpha = 5.7;
beta = 33;

%clusters = featureSelection(t_truth, alpha, beta);
t_test_ = t_test;
t_test_(t_test_ == 99) = 0;
t_test_ = dataReduction(t_test_, clusters);
t_test_(t_test_ == 0) = 99;
t_truth_ = dataReduction(t_truth, clusters);

% now see the error for prediction before/after featureReduction
% without reduction: rmse=4.0782
% with reduction   : rmse=4.3782
data = t_test_;

% the matrix is M x N
% m is the users, n is the jokes
[M,N] = size(data);

% Let “Omega” be the indeces of the observed entries
% i.e the indeces of user ratings ratings that does not equal to 99
omega = find(data ~= 99 & data ~= 55);

% the observed entries themselves, not their indeces
% i.e these are the user ratings
observations = data(omega);

% smoothing parameter
mu = 0.0001;

% The solver runs in seconds
tic
estm = solver_sNuclearBP( {M,N,omega}, observations, mu );
toc

[ confusion, rmse, ame ] = calcError(t_truth_, data, estm, [55 99]);















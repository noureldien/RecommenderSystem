clc;

% motivation
% features are redundant / irrelevant, that's why
% we try to find the best features and neglect the others
% if I managed to reduce features and get better rmse on fourk dataset
% I'm quite sure this will help in imporving the prediction when
% using the actual test set and submit the results on kaggle

% first algorithm
clc;

% include directories
addpath(genpath('./Data/'));
addpath(genpath('./Shared/'));

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');

% the matrix is M x N
% m is the users, n is the jokes
M   = 3000;
N   = 100;
[M,N] = size(t_truth);

% just train your model on a small portion
t_test = t_test(1:M,:);
t_test = t_test(:,1:N);

% truth
t_truth = t_truth(1:M,:);
t_truth = t_truth(:,1:N);

% replace missing by 0
% t_test(t_test == 99) = 0;

% mainly, use the complete data to do dimentionality reduction
% the complete data is the t_truth, as it doesn't have any missing value

% getting the variances of the features
variances = var(t_truth);

feature = t_truth(:,36);

figure(1); clf;
hold on;
grid on;
box on;
plot(variances);
title('Using complete data, variances for all features');

figure(2); clf;
hold on;
box on;
grid on;
subplot(1,2,1);
plot(feature, '.');
title('Using complete data: ratings for feature 36, variance ~17');
hold on;
box on;
grid on;
subplot(1,2,2);
boxplot(feature);
title('Using complete data: ratings for feature 36, variance ~17');


% from initial screening, some feature have steady ratings (i.e. low variance)
% like feature 50, ratings from 2:6
% others have high-variance ratings
% like feature 71, ratings from from 5:-6







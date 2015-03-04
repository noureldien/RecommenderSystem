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
% variances = var(t_truth);

figure(1); clf;
hold on;
grid on;
box on;
plot(variances);
title('Using complete data, variances for all features');

% loop on all the features and get their

for i=82:82
    
    % 36, 50, 71
    featureN = i;
    
    % some operations on the feature
    % to make it more able to be visalized
    feature = t_truth(:,featureN);
    feature_sorted = sort(feature);
    % round the ratings to the nearest int values
    % so we can draw a histogram
    feature_approx = double(int16(feature));
    % get counts and bin of histogram
    [feature_histo_c,feature_histo_b] = hist(feature_approx);   
    
    figure(2); clf;
    hold on;
    box on;
    grid on;
    subplot(1,3,1);
    plot(feature, '.');
    title('Using complete data: sorted ratings for feature 36');
    
    hold on;
    box on;
    grid on;
    subplot(1,3,2);
    barh(feature_histo_b,feature_histo_c);
    title(strcat('Using complete data: histogram for feature ', num2str(featureN)));
    
    hold on;
    box on;
    grid on;
    subplot(1,3,3);
    boxplot(feature);
    title(strcat('Using complete data: mean ratings for feature ', num2str(featureN)));
    
    % from initial screening, some feature have steady ratings (i.e. low variance)
    % like feature 50, ratings from 2:6
    % others have high-variance ratings
    % like feature 71, ratings from from 5:-6
    
    pause(0.001);
end







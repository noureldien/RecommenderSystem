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
load('Data\fourk.mat');
load('Data\fourk55.mat');
load('Data\train.mat');
load('Data\test.mat');

% the matrix is M x N
% m is the users, n is the jokes
% all the analysis will be done on small space (2D)
% then later on, it will be scaled up to the full space (100D)
M   = 6000;
N   = 100;
[M,N] = size(t_truth);

% take small portion of the data
t_train = t_train(1:M,1:N);
t_test = t_test(1:M,1:N);
t_truth = t_truth(1:M,1:N);

% replace missing by 0
% t_test(t_test == 99) = 0;

% this is an attempt to do dimentionality reduction
% on the t_test we have, these are the steps
% 1. Find the least discremenant feature and throw it ()

% mainly, use the complete data to do dimentionality reduction
% the complete data is the t_truth, as it doesn't have any missing value

% getting the variances of the features
%variances = var(t_truth);

% getting PCA
%[pca_coeff, pca_score, pca_latent, pca_tsquare] = princomp(t_truth);

% get the correlation matrix of the
for i=82:82
    
    % 36, 50, 71
    featureN = i;
    
    % some operations on the feature
    % to make it more able to be visalized
    feature = t_truth(:,featureN);
    
    % get counts and bin of histogram
    %[feature_histo_c,feature_histo_b] = hist(feature_approx);   
    
    figure(2); clf;
    hold on;
    box on;
    grid on;
    subplot(1,3,2);
    barh(feature_histo_b,feature_histo_c);
    title(strcat('Using complete data: histogram for feature ', num2str(featureN)));
        
    pause(0.001);
end












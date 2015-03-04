% using the best algo to do the final prediction on the final
% test data and submit the result to kaggle
clc;

addpath(genpath('./cvx/'));
addpath(genpath('./TFOCS/'));
addpath(genpath('./Shared/'));

% load the data
load('Data\train.mat');
load('Data\test.mat');

test = [train; test];

% the matrix is M x N
% m is the users, n is the jokes
[M,N] = size(test);

% Let “Omega” be the indeces of the observed entries
% i.e the indeces of user ratings ratings that does not equal to 99
omega = find(test ~= 99 & test ~= 55);

% the observed entries themselves, not their indeces
% i.e these are the user ratings
observations = test(omega);

% smoothing parameter
mu = 0.0005;

% The solver runs in seconds
tic
estm = solver_sNuclearBP( {M,N,omega}, observations, mu );
toc














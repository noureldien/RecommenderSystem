% this is the 8th experiment to carry out
% what's new here is we involve feature reduction
% before matrix factorization

clc;

addpath(genpath('..\cvx\'));
addpath(genpath('..\TFOCS\'));
addpath(genpath('..\Shared\'));

% load the data
load('Data\t_truth.mat');
load('Data\test.mat');
load('Data\train.mat');

% do feature reduction/selection
varianceThreshold = 33;
errorThreshold = 4.7;
clusters = featureSelection(t_truth, errorThreshold, varianceThreshold, []);
%clusters = featureSelection(train, errorThreshold, varianceThreshold, [99, 55]);
%clusters = featureSelection([t_truth; test], errorThreshold, varianceThreshold, [99, 55]);

test = [t_truth; test];
test(test == 99) = 0.00099;
test(test == 55) = 0.00055;
test = dataReduction(test, clusters);
test(test == 0.00099) = 99;
test(test == 0.00055) = 55;

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
mu = 0.0001;

% The solver runs in seconds
tic
estm = solver_sNuclearBP( {M,N,omega}, observations, mu );
toc

% recover the data to it's N features (before reduction)
estm = dataRecovery(estm, clusters, 100);

% recover the original data used in training
load('Data\test.mat');
test = [t_truth; test];

% save the results
saveResult(test, estm, 13);












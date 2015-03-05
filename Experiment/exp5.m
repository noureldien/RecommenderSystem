% this is the 5th experiment to carry out
% based on CVX toolbox
% it is mentioned in this article
% http://www.convexoptimization.com/wikimization/index.php/Matrix_Completion

clc;

addpath(genpath('..\cvx\'));
addpath(genpath('..\TFOCS\'));
addpath(genpath('..\Shared\'));

% load the data
load('Data\train.mat');
load('Data\test.mat');
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');

% the matrix is M x N
% m is the users, n is the jokes
test = [t_truth; test];

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
epsilon = 0.001;

% The solver runs in seconds
% tic
% estm = solver_sNuclearBP( {M,N,omega}, observations, mu );
% toc

% or we could use relaxted parameter for faster solution
tic
estm = solver_sNuclearBPDN( {M,N,omega}, observations, epsilon, mu );
toc

% save the results
saveResult(test, estm, 17);









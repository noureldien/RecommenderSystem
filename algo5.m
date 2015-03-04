% this is the fifth technique to use
% based on CVX toolbox
% it is mentioned in this article
% http://www.convexoptimization.com/wikimization/index.php/Matrix_Completion

clc;

addpath(genpath('./cvx/'));
addpath(genpath('./TFOCS/'));
addpath(genpath('./Shared/'));

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');

% the matrix is M x N
% m is the users, n is the jokes
M   = 1000;
N   = 20;

% just train your model
% on a small portion of the t_test
t_test = t_test(1:M,:);
t_test = t_test(:,1:N);

% Our target matrix, i.e our ground-truth
t_truth = t_truth(1:M,:);
t_truth = t_truth(:,1:N);

% Let “Omega” be the indeces of the observed entries
% i.e the indeces of user ratings ratings that does not equal to 99
omega = find(t_test ~= 99);

% the observed entries themselves, not their indeces
% i.e these are the user ratings
observations = t_truth(omega);

% smoothing parameter
mu = 0.00001;
epsilon = 0.01;

% The solver runs in seconds
tic
t_estm = solver_sNuclearBP( {M,N,omega}, observations, mu );
toc

% or we could use relaxted parameter for faster solution
%t_estm = solver_sNuclearBPDN( {M,N,omega}, observations, epsilon, mu );

% random walk, if I just placed zero
% (i.e the average number), what would happen
t_rand = t_test;
t_rand(t_rand == 99) = 0;

% get the errors
[confusionEstm, rmseEstm, ameEstm] = calcError(t_truth, t_test, t_estm, 99);
[confusionRand, rmseRand, ameRand] = calcError(t_truth, t_test, t_rand, 99);

% plot results
plotResult(confusionEstm, rmseEstm, ameEstm, confusionRand, rmseRand, ameRand);









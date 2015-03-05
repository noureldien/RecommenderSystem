% this is the 6th experiment to carry out
% but this experiment is done over the fourk dataset
% based on CVX toolbox
% it is mentioned in this article
% http://www.convexoptimization.com/wikimization/index.php/Matrix_Completion

clc;

addpath(genpath('..\cvx\'));
addpath(genpath('..\TFOCS\'));
addpath(genpath('..\Shared\'));

% load the data
load('..\Data\fourk.mat');
load('..\Data\fourk55.mat');

t_truth = fourk;
t_test = fourk55;

% the matrix is M x N
% m is the users, n is the jokes
[M, N] = size(t_truth);

% Let “Omega” be the indeces of the observed entries
% i.e the indeces of user ratings ratings that does not equal to 99 and 55
omega = find(t_test ~= 99 & t_test ~= 55);

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
t_rand(t_rand == 99 | t_rand == 55) = 0;

% get the errors
idx = find(t_test == 55);
rmse = abs(t_truth(idx) - t_estm(idx))';
rmse = reshape(rmse,[size(rmse,1)*size(rmse,2),1]);
ame = mean(rmse);
rmse = sqrt(mean((rmse).^2));
disp(rmse);





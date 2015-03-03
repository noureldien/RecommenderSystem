% this is the first technique to use
% it is mentioned in this article
% it's fairly easy and used just as a warm-up
% http://www.quuxlabs.com/blog/2010/09/matrix-factorization-a-simple-tutorial-and-implementation-in-python/

clc;

addpath(genpath('./MF/'));
addpath(genpath('./Shared/'));

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');

% the matrix is M x N
% m is the users, n is the jokes
M   = 500;
N   = 10;

% size of the latent features
K = 20;

% parameters of the alogirthm
%alpha : the learning rate
%beta  : the regularization parameter
steps = 1000;
alpha = 0.001;
beta = 0.2;

% just train your model
% on a small portion of the t_test
t_test = t_test(1:M,:);
t_test = t_test(:,1:N);

% truth
t_truth = t_truth(1:M,:);
t_truth = t_truth(:,1:N);

% because this model is built to work
% on ranges from 1 to N (0 is missing data)
% and the training data we have is a bit diffirent
% (ranges of ratings form -10 to 10, where 99 is a missing data)
% so, these 2 lines is to fix that
t_test(t_test == 99) = -11;
t_test = t_test + 11;

% factorize the rating matrix
P = rand(M,K);
Q = rand(N,K);

[P, Q] = naiveMF(t_test, P, Q, K, steps, alpha, beta);
t_estm = P*Q';

% shift back the data
t_estm = t_estm - 11;
t_test = t_test - 11;

% random walk, if I just placed zero
% (i.e the average number), what would happen
t_rand = t_test;
t_rand(t_rand == -11) = 0;

% get the errors
[confusionEstm, rmseEstm, ameEstm] = calcError(t_truth, t_test, t_estm, -11);
[confusionRand, rmseRand, ameRand] = calcError(t_truth, t_test, t_rand, -11);

% plot results
plotResult(confusionEstm, rmseEstm, ameEstm, confusionRand, rmseRand, ameRand);








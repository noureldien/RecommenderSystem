% this is the first technique to use
% it is mentioned in this article
% it's fairly easy and used just as a warm-up
% http://www.quuxlabs.com/blog/2010/09/matrix-factorization-a-simple-tutorial-and-implementation-in-python/

clc;

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');

R = [5,3,0,1;
    4,0,0,1;
    1,1,0,5;
    1,0,0,4;
    0,1,5,4];

R = t_test;
R = R(1:100,:);
R = R(:,1:20);

R(R == 99) = -11;
R = R + 11;

% size of the rating matrix
[N, M] = size(R);

% size of the latent features
K = 10;

% parameters of the alogirthm
steps=5000;
alpha=0.0002;
beta=0.02;

% factorize the rating matrix
P = rand(N,K);
Q = rand(M,K);

[nP, nQ] = matrixFactorization(R, P, Q, K, steps, alpha, beta);
nR = nP*nQ';

% check against truth
%nR vs. t_truth








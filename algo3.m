% this is the third technique to use
% A Singular Value Thresholding Algorithm for Matrix Completion
% it is mentioned in this article
% http://www.convexoptimization.com/wikimization/index.php/Matrix_Completion
% and the paper is here
% http://arxiv.org/abs/0810.3286

clc;
addpath(genpath('./SVT/'));
mex ./SVT/updateSparse.c;

% Setup a matrix
randn('state',2008);
rand('state',2008);

m = 1000;
n = 50;
r = 10;
target = randn(m,r)*randn(r,n);

% degrees of freedom
df = r*(m*n-r);

% matrix rank
k = 100;

oversampling = 5;

% index of our observation data, observations
% are always part of the target matrix, while the other
% remaining data are the missing ones that we need to predict
Omega = randsample(m*n,k);
train = target(Omega);

% Set parameters and solve
p = k/(m*n);  delta = 1.2/p;
maxiter = 500;
tolerance = 1e-4;

% Approximate minimum nuclear norm solution by SVT algorithm
tic
[U,S,V,numiter] = SVT(m,n,Omega,train,delta,maxiter,tolerance);
toc

% Show results
X = U*S*V';

disp(sprintf('The relative error on Omega is: %d ', norm(train-X(Omega))/norm(train)))
disp(sprintf('The relative recovery error is: %d ', norm(target-X,'fro')/norm(target,'fro')))
disp(sprintf('The relative recovery in the spectral norm is: %d ', norm(target-X)/norm(target)))
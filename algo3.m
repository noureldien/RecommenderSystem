% this is the third technique to use
% A Singular Value Thresholding Algorithm for Matrix Completion
% it is mentioned in this article
% http://www.convexoptimization.com/wikimization/index.php/Matrix_Completion
% and the paper is here
% http://arxiv.org/abs/0810.3286

clc;
%addpath(genpath('./SVDT/'));
%mex updateSparse.c;

% Setup a matrix
randn('state',2008);
rand('state',2008);

n = 1000;  r = 10;
M = randn(n,r)*randn(r,n);

df = r*(2*n-r);
oversampling = 5;  m = 5*df;

Omega = randsample(n^2,m);
data = M(Omega);

% Set parameters and solve
p = m/n^2;  delta = 1.2/p;
maxiter = 500;
tol = 1e-4;

% Approximate minimum nuclear norm solution by SVT algorithm
tic
[U,S,V,numiter] = SVT(n,Omega,data,delta,maxiter,tol);
toc

% Show results
X = U*S*V';

disp(sprintf('The relative error on Omega is: %d ', norm(data-X(Omega))/norm(data)))
disp(sprintf('The relative recovery error is: %d ', norm(M-X,'fro')/norm(M,'fro')))
disp(sprintf('The relative recovery in the spectral norm is: %d ', norm(M-X)/norm(M)))
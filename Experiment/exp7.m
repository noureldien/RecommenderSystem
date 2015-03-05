% this is the 7th experiment to carry out
% it's not really of an algo but rather an improvement of algo5
% it's a trial to suck the last bit of juice out of algo 5
% from the feature analysis I did, I noticed that the training set
% is very correlated to the test set
% if we can embed the test inside the training and train them together
% may be this will improve the result
% permutation didn't work, but a slight improvement is acheived
% by using t_truth + test in training

clc;

addpath(genpath('..\cvx\'));
addpath(genpath('..\TFOCS\'));
addpath(genpath('..\Shared\'));

% load the data
load('..\Data\t_truth.mat');
load('..\Data\train.mat');
load('..\Data\test.mat');

test = [t_truth; test];

% the matrix is M x N
% m is the users, n is the jokes
[M,N] = size(test);

permIdx = randperm(N);
test_perm = zeros(M, N);

% permute
for i=1:N
    test_perm(:,i) = test(:,permIdx(i));
end

% Let “Omega” be the indeces of the observed entries
% i.e the indeces of user ratings ratings that does not equal to 99
omega = find(test_perm ~= 99 & test_perm ~= 55);

% the observed entries themselves, not their indeces
% i.e these are the user ratings
observations = test_perm(omega);

% smoothing parameter
mu = 0.0001;

% The solver runs in seconds
tic
estm_perm = solver_sNuclearBP( {M,N,omega}, observations, mu );
toc

% recover the original arrange from permutation
estm = zeros(M,N);
for i=1:N
    test(:,permIdx(i)) = test_perm(:,i);
    estm(:,permIdx(i)) = estm_perm(:,i);
end















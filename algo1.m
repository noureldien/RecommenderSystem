% this is the first technique to use
% it is mentioned in this article
% it's fairly easy and used just as a warm-up
% http://www.quuxlabs.com/blog/2010/09/matrix-factorization-a-simple-tutorial-and-implementation-in-python/

clc;

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');

% just train your model
% on a small portion of the t_test
R = t_test;
R = R(1:50,:);
R = R(:,1:6);

% truth 
T = t_truth;
T = T(1:50,:);
T = T(:,1:6);

% because this model is built to work
% on ranges from 1 to N (0 is missing data)
% and the training data we have is a bit diffirent
% (ranges of ratings form -10 to 10, where 99 is a missing data)
% so, these 2 lines is to fix that
R(R == 99) = -11;
R = R + 11;

% size of the rating matrix
[N, M] = size(R);

% size of the latent features
K = 8;

% parameters of the alogirthm
%alpha : the learning rate
%beta  : the regularization parameter
steps=5000;
alpha=0.001;
beta=0.2;

% factorize the rating matrix
P = rand(N,K);
Q = rand(M,K);

[nP, nQ] = naiveMF(R, P, Q, K, steps, alpha, beta);
nR = nP*nQ';

% shift back the data
nR = nR - 11;

% check against truth
%nR vs. t_truth
confusion = abs(nR - T)';
rmse = reshape(confusion,[size(confusion,1)*size(confusion,2),1]);
rmse = sqrt(mean((rmse).^2));
disp(strcat('Final Error: ', num2str(rmse)));

% plot the result
figure(1); clf;
imshow(confusion, 'InitialMagnification', 1000);
title(strcat('RMSE: ', num2str(rmse)));
colormap(jet);
colorbar;








% this is the fifth technique to use
% based on CVX toolbox
% it is mentioned in this article
% http://www.convexoptimization.com/wikimization/index.php/Matrix_Completion

clc;

addpath(genpath('./cvx/'));
addpath(genpath('./TFOCS/'));

rng('default');    % for reproducible results
N   = 20;       % the matrix is M x N
M   = 100;      % m is the users, n is the jokes
r   = 2;        % the rank of the matrix
df  = M*N*r - r^2;  % degrees of freedom of a N x N rank r matrix
nSamples    = 0.4*df; % number of observed entries

% For this demo, we will use a matrix with integer entries
% because it will make displaying the matrix easier.
iMax    = 5;
X       = randi(iMax,M,r)*randi(iMax,r,N); % Our target matrix

%Now suppose we only see a few entries of X. Let “Omega” be the set of observed entries
rPerm   = randperm(M*N); % use "randsample" if you have the stats toolbox
omega   = sort( rPerm(1:nSamples) );

%Print out the observed matrix in a nice format.
% The “NaN” entries represent unobserved values.
% The goal of this demo is to find out what those values are!

Y = nan(M,N);
Y(omega) = X(omega);

observations = X(omega);    % the observed entries
mu           = .001;        % smoothing parameter

% The solver runs in seconds
tic
Xk = solver_sNuclearBP( {M,N,omega}, observations, mu );
toc

% replace NaN with zero
Y_ = Y;
Y_(find(isnan(Y))) = 0;

t_estimated = Xk;
t_truth = X;
t_test = Y_;
% check against truth
confusionTrain = abs(t_estimated - t_truth)';
confusionTruth = abs(t_test - t_truth)';
rmseTrain = reshape(confusionTrain,[size(confusionTrain,1)*size(confusionTrain,2),1]);
rmseTrain = sqrt(mean((rmseTrain).^2));
rmseTruth = reshape(confusionTruth,[size(confusionTruth,1)*size(confusionTruth,2),1]);
rmseTruth = sqrt(mean((rmseTruth).^2));

disp(strcat('Final Error: ', num2str(rmseTrain)));

% plot the result
figure(2); clf;
subplot(2,1,1);
imshow(confusionTrain, 'InitialMagnification', 1000);
title(strcat('RMSE: ', num2str(rmseTrain)));
colormap(jet);
colorbar;
subplot(2,1,2);
imshow(confusionTruth, 'InitialMagnification', 1000);
title(strcat('RMSE: ', num2str(rmseTruth)));
colormap(jet);
colorbar;










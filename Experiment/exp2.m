% this is the 2nd experiment to carry out
% it is simply SVD free Low rank matrix recovery
% In this formulation, nuclear norm is replaced by equivalent Ky-Fan norm
% This eliminates need for complex singular value decomposition at every
% iteration and just requires simple least squares at every step
% We solve
% min_X ||y-A(x)||_2 + lambda_n||X||_ky-fan equivalent to
% min_X ||y-A(x)||_2 + lambda_n[trace{(X'*X)_0.5}]

clc;

% load the data
load('..\Data\t_train.mat');
load('..\Data\t_test.mat');
load('..\Data\t_truth.mat');

% just train your model
% on a small portion of the t_test
t_test = t_test(1:50,:);
t_test = t_test(:,1:6);

% truth
t_truth = t_truth(1:50,:);
t_truth = t_truth(:,1:6);

% because this model is built to work
% on ranges from 1 to N (0 is missing data)
% and the training data we have is a bit diffirent
% (ranges of ratings form -10 to 10, where 99 is a missing data)
% so, these 2 lines is to fix that
t_test(t_test == 99) = -11;
t_test = t_test + 11;

gm = 1.5265;
IDX = find(t_test);
sizeX = size(t_test);

%create sampling operator
global Aop
Aop = opRestriction(prod(sizeX), IDX);

% Set paramteres
max_iter = 1000;
lambda_n = 12.01;
lambda_b = 0.001;

% call function
[X , bi,  bu] = trace_form_nobreg(t_test,gm,Aop,sizeX,lambda_n,max_iter,lambda_b);

recovered = [];
for r=1:size(X,1)
    r
    recovered(r,:) = X(r,:) + bu(r,:) + bi + gm;
end

% check against truth
%nR vs. t_truth
confusionTrain = abs(recovered - t_truth)';
confusionTruth = abs(t_test - t_truth)';
rmseTrain = reshape(confusionTrain,[size(confusionTrain,1)*size(confusionTrain,2),1]);
rmseTrain = sqrt(mean((rmseTrain).^2));
rmseTruth = reshape(confusionTruth,[size(confusionTruth,1)*size(confusionTruth,2),1]);
rmseTruth = sqrt(mean((rmseTruth).^2));

disp(strcat('Final Error: ', num2str(rmseTrain)));

% plot the result
figure(1); clf;
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






% this is the 4th experiment to carry out
% based on very stupid SVD on Matlab
% total failure in this alog

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
%t_test = t_test + 11;

% perform SVD and get the esitmated user ratings
[U,S,V] = svd(t_test, 0);
t_estimated = U*S*V';

% shift back the data
%t_estimated = t_estimated - 11;
%t_test = t_test - 11;

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







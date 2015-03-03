clc;

nR = x_recovered;
T = testset;

% check against truth
%nR vs. t_truth
confusionTrain = abs(nR - T)';
rmseTrain = reshape(confusionTrain,[size(confusionTrain,1)*size(confusionTrain,2),1]);
rmseTrain = sqrt(mean((rmseTrain).^2));

idx = T(T~=0);
confusionTrain_ = zeros(size(T,1),size(T,2));
confusionTrain_(idx) = abs(nR(idx)- T(idx));
rmseTrain_ = sqrt(sum(sum(confusionTrain_.^2))/length(find(confusionTrain_)));

disp(strcat('Final Error: ', num2str(rmseTrain)));
disp(strcat('Final Error_: ', num2str(rmseTrain_)));

% plot the result
figure(1); clf;
imshow(confusionTrain', 'InitialMagnification', 40);
title(strcat('RMSE: ', num2str(rmseTrain)));
colormap(jet);
colorbar;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

% clc;
% % addpath(genpath('/libs/latexfigure/'));
% 
% load('data\train.mat');
% load('data\test.mat');
% 
% indexes = [];
% ratings = [];
% 
% [train_h,train_w] = size(trainset);
% colum_data = [];
% 
% for i=1:10
%     
%     % remove samples with missing rating
%     %indexes = find(trainset(:,i) == 99);
%     %colum_data = trainset(:,i);
%     %colum_data(indexes) = [];
%     
%     figure (i); clf;
%     boxplot(colum_data);
% end







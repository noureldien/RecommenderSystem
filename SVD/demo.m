% This is a demo for SVD free Low rank matrix recovery
% In this formulation, nuclear norm is replaced by equivalent Ky-Fan norm
% This eliminates need for complex singular value decomposition at every
% iteration and just requires simple least squares at every step

% We solve
% min_X ||y-A(x)||_2 + lambda_n||X||_ky-fan equivalent to 
% min_X ||y-A(x)||_2 + lambda_n[trace{(X'*X)_0.5}]

clc;
clear all;
close all;

%load test and train datasets
load data.mat;
train=m22;
testset = m2;
gm = g_mean2; 
IDX = find(train);
sizeX=size(train);

%create sampling operator
global Aop
Aop = opRestriction(prod(sizeX), IDX);

% Set paramteres
max_iter=100;
lambda_n=1e1; 
lambda_b = 1e-3;

% call function
[X , bi,  bu]= trace_form_nobreg(train,gm,Aop,sizeX,lambda_n,max_iter,lambda_b);

  for r=1:size(X,1)             
      x_recovered(r,:)=X(r,:)+bu(r,:)+bi+gm;       
  end

%Compute Error in terms of MAE (mean absolute error)     
mae = error_rate(testset,x_recovered)



nR = x_recovered;
T = testset;

% % check against truth
% %nR vs. t_truth
% confusionTrain = abs(nR - T)';
% rmseTrain = reshape(confusionTrain,[size(confusionTrain,1)*size(confusionTrain,2),1]);
% rmseTrain = sqrt(mean((rmseTrain).^2));
% 
% idx = T(T~=0);
% confusionTrain_ = zeros(size(T,1),size(T,2));
% confusionTrain_(idx) = abs(nR(idx)- T(idx));
% rmseTrain_ = sqrt(sum(sum(confusionTrain_.^2))/length(find(confusionTrain_)));
% 
% disp(strcat('Final Error: ', num2str(rmseTrain)));
% disp(strcat('Final Error_: ', num2str(rmseTrain_)));
% 
% % plot the result
% figure(1); clf;
% imshow(confusionTrain', 'InitialMagnification', 40);
% title(strcat('RMSE: ', num2str(rmseTrain)));
% colormap(jet);
% colorbar;
 
  


 
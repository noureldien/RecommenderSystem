% this is the first technique to use
% it is simply SVD free Low rank matrix recovery
% In this formulation, nuclear norm is replaced by equivalent Ky-Fan norm
% This eliminates need for complex singular value decomposition at every
% iteration and just requires simple least squares at every step
% We solve
% min_X ||y-A(x)||_2 + lambda_n||X||_ky-fan equivalent to 
% min_X ||y-A(x)||_2 + lambda_n[trace{(X'*X)_0.5}]

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








%load the data
load data.mat;
trainSet = m22;
testSet = m2;

gm = 3.5265; 
IDX = find(trainSet);
sizeX=size(trainSet);

%create sampling operator
global Aop
Aop = opRestriction(prod(sizeX), IDX);

% Set paramteres
max_iter=100;
lambda_n= 10; 
lambda_b = 0.001;

% call function
[X , bi,  bu]= trace_form_nobreg(trainSet,gm,Aop,sizeX,lambda_n,max_iter,lambda_b);

  for r=1:size(X,1)             
      recovered(r,:)=X(r,:)+bu(r,:)+bi+gm;       
  end

%Compute Error in terms of MAE (mean absolute error)     
mae = error_rate(testSet,recovered)
 
  


 
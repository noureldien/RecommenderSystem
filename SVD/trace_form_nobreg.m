function [X  bi bu]= trace_form_nobreg(train,gm,Aop,s_x,lambda_n,iter,lambda_b)
% function [x_out  bi bu  er]= trace_form_nobreg(train,Aop,s_x,lambda_n,iter)

% In this formulation, nuclear norm is replaced by equivalent Ky-Fan norm
% This eliminates need for complex singular value decomposition at every
% iteration and just requires simple least squares at every step

% We solve
% min_X ||y-A(x+ bu+bi)||_2 + lambda_n||X||_ky-fan + lambda_b (||bu||_2 +||bi||_2)
% equivalent to 
% min_X ||y-A(x+ bu+bi)||_2 + lambda_n[trace{(X'*X)_0.5}]+ lambda_b (||bu||_2 +||bi||_2)

% INPUTS
%train : training set
%Aop : sub-sampling operator
%s_x : Size of data matrix
%lambda_n : regularziation paranmter
%iter : maximum number of iterations

% OUTPUTS
% X : Recpvered interaction component
% bu : user bias
% bi : item bias

%Initialize variables
X=randn(s_x);
bi=randn(1,s_x(2));
bu=randn(s_x(1),1);
[i j v]=find(train);
train_data=[i j v];
b = Aop(train(:),1);

 for iteration=1:iter
     iteration
     Bu=repmat(bu,1,s_x(2));
     Bi=repmat(bi,s_x(1),1); 
     bbcs=Bu+Bi+gm;
  
     % Compute interaction portion
     yvec=b-Aop(bbcs(:),1);
     ynew=X(:)+Aop((yvec-Aop(X(:),1)),2);
     Ymat=reshape(ynew,s_x);
 
     Xoper=eye(s_x(1)) + lambda_n*((X*X')^(-1/2));
     X=Xoper\Ymat;
      
     % Compute biases 
     [bi, bu]=bias_sgd(train_data,X,bu,bi,gm,lambda_b);
    
 end
 
end











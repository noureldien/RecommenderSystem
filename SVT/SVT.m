function [U,Sigma,V,numiter] = SVT(m,n,Omega,b,delta,maxiter,tol)
% 
% Finds the minimum of  tau ||X||_* + .5 || X ||_F^2 
%           subject to  P_Omega(X) == P_Omega(M)
% using linear Bregman iterations
%
% Usage:  [U,S,V,numiter] = SVT(n,Omega,b,delta,maxiter,opts)
%
% Inputs:
% n - width of the matrix X (m*n)
% m - height of the matrix X (m*n)
% Omega - set of observed entries
% b - data vector of the form M(Omega)
% delta - step size 
% maxiter - maximum number of iterations
%
% Outputs: matrix X stored in SVD format X = U*diag(S)*V'
% U - mxr left singular vectors  
% S - rx1 singular values
% V - nxr right singular vectors 
% numiter - number of iterations to achieve convergence

% Description: 
% Reference:
%
%    Cai, Candes and Shen
%    A singular value thresholding algorithm for matrix completion
%    Submitted for publication, October 2008.
%
% Written by: Emmanuel Candes
% Email: emmanuel@acm.caltech.edu
% Created: October 2008

l = length(Omega);  [temp,indx] = sort(Omega); 
tau = 5*n;  incre = 5; 

[i, j] = ind2sub([m,n], Omega);
ProjM = sparse(i,j,b,m,n,l);

normProjM = normest(ProjM);
k0 = ceil(tau/(delta*normProjM));

normb = norm(b);

y = k0*delta*b;
Y = sparse(i,j,y,m,n,l);
r = 0;

fprintf('\nIteration:   ');
for k = 1:maxiter
    fprintf('\b\b\b%3d',k); 
    s = r + 1;
    
    OK = 0;
    while ~OK 
        [U,Sigma,V] = lansvd(Y,s,'L');
        OK = Sigma(s,s) <= tau;
        s = s + incre;
    end
   
    sigma = diag(Sigma);  r = sum(sigma > tau);
    U = U(:,1:r);  V = V(:,1:r);  sigma = sigma(1:r) - tau;  Sigma = diag(sigma);
    
    A = U*diag(sigma)*V';
    x = A(Omega);
    
    if norm(x-b)/normb < tol
        break
    end
    
   y = y + delta*(b-x);
   updateSparse(Y,y,indx);   
end

fprintf('\n');
numiter = k;
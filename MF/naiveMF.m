function [ P, Q ] = naiveMF( R, P, Q, K, steps, alpha, beta )
% naive way of matrix factorization
% http://www.quuxlabs.com/blog/2010/09/matrix-factorization-a-simple-tutorial-and-implementation-in-python/
% INPUT:
%     R     : a matrix to be factorized, dimension N x M
%     P     : an initial matrix of dimension N x K
%     Q     : an initial matrix of dimension M x K
%     K     : the number of latent features
%     steps : the maximum number of steps to perform the optimisation
%     alpha : the learning rate
%     beta  : the regularization parameter
% OUTPUT:
%     the final matrices P and Q

[N, M] = size(R);

Q = Q';
for step = 1:steps
    step
    for i=1:N
        for j=1:M
            if(R(i,j)>0)
                eij = R(i,j) - P(i,:)*Q(:,j);
                for k=1:K
                    P(i,k) = P(i,k) + alpha * (2 * eij * Q(k,j) - beta * P(i,k));
                    Q(k,j) = Q(k,j) + alpha * (2 * eij * P(i,k) - beta * Q(k,j));
                end
            end
        end
    end
    eR = P*Q;
    e = 0;
    for i=1:N
        for j=1:M
            if(R(i,j)>0)
                e = (R(i,j) - (P(i,:)*Q(:,j)))^2;
                for k=1:K
                    e = e + (beta/2) * (P(i,k)^2 + Q(k,j)^2);
                end
            end
        end
    end
    if (e < 0.001)
        break;
    end
end
Q = Q';

end


function [ estm ] = dataCompletion( data, missings )

% do matrix completion using the given data, complete the missing
% number as given in the missings array
%
% INPUT:
%           data : the matrix we want to complete
%       missings : the missing numbers in the test we want to predict
% OUTPUT:
%           estm : the test matrix but with the estimated missing values

% the matrix is M x N
[M,N] = size(data);

omega = [];
for i=1:length(missings)
    if (isempty(omega))
        omega = find(data ~= missings(i));
    else
        omega = intersect(omega, find(data ~= missings(i)));
    end  
end

observations = data(omega);
mu = 0.0001;

% do the estimation
estm = solver_sNuclearBP( {M,N,omega}, observations, mu );

end


function [ estm ] = dataPrediction( train, test, trainMissings, testMissings, mu )

% given the matrix that contains the user patterns
% and another matrix that contains the users of the test set
% predict the missing data in the test by matching each test user
% with the correlated pattern
%
% INPUT:
%           patterns : the matrix we shall use in training
%               test : the matrix we want to predict the missing values in it
%      trainMissings : the missing numbers in the training matrix
%                      it is important to know so as to avaid these numbers when
%                      doing matching between the test and it's pattern
%       testMissings : the missing numbers in the test we want to predict
%                 mu : smoothening rate
% OUTPUT:
%               estm : the test matrix but with the estimated missing values


% match each user in the test set with the patterns
% but one point we want to take care of when matching
% is we don't consider the missing features while matching
% only depend of the available features

% after matching, predict the missing values

% for the sake of time, instead of doing what I want
% i'd depend on matrix completion here

% the matrix is M x N
data = [train; test];
[M,N] = size(data);

omega = [];
for i=1:length(testMissings)
    if (isempty(omega))
        omega = find(data ~= testMissings(i));
    else
        omega = intersect(omega, find(data ~= testMissings(i)));
    end  
end

observations = data(omega);

% smoothing parameter
if (nargin < 5)
    mu = 0.0001;
end

% do the estimation
estm = solver_sNuclearBP( {M,N,omega}, observations, mu );

% take the last part and return it as the estimate
offset = M + 1 - size(test,1);
estm =  estm(offset:end,:);

end


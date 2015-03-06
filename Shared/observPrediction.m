function [ estm ] = observPrediction( patterns, test, pMissings, tMissings )

% given the matrix that contains the user patterns
% and another matrix that contains the users of the test set
% predict the missing data in the test by matching each test user
% with the correlated pattern
%
% INPUT:
%           patterns : the matrix of user patterns
%               test : the matrix we want to predict the missing values in it
%          pMissings : even the matrix of the patterns can contain missings
%                      numbers, it is important to know so as to avaid these numbers when
%                      doing matching between a user in the test and it's pattern
%          tMissings : the missing numbers in the test we want to predict
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
data = [patterns; test];
[M,N] = size(data);

omega = find(data ~= 99 & data ~= 55);
observations = data(omega);

% smoothing parameter
mu = 0.0001;
epsilon = 0.0001;

% do the estimation
estm = solver_sNuclearBP( {M,N,omega}, observations, mu );

% take the last part (which equal in M to the test )
% and return it as the estimate
offset = size(estm,1) + 1 - size(test,1);
estm =  estm(offset:end,:);

end


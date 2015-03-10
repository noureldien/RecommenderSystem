% much like experiment 15 except that instead of
% predicting 99 for train+test using knn not averaging

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');
load('Data\traintestKnn.mat');

data = [train; test];
estm99 = traintestKnn;

offsetTr = size(train,1);
offsetTs = offsetTr + 1;

train99 = estm99(1:offsetTr,:);
test99 = estm99(offsetTs:end,:);

% add train+test and predict the 55
estm99 = dataPrediction(train99,test,[], [55 99]);

% add 55 to the estm
test_ = estm99;
test_(test==55) = 55;

% estimate the 55 for training again
estm = dataCompletion(test_, [55]);

% save the results
saveResult(test, estm, 42);








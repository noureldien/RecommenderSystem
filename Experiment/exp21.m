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

% add 55 to the test
test_ = test99;
test_(test==55) = 55;

% add train+test and predict the 55
estm = dataPrediction(train99,test_,[], [55]);

% if you've used them as one matrix, you would have
% to split the estimate. dataPrediction does that for you
%data = [train99 test_];
%estm = dataCompletion(data, [55]
%estm =  estm(offset:end,:); 

% save the results
saveResult(test, estm, 32);








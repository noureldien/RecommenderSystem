% in this experiment, we want to investigate
% the effect of local estimates on the t_trainKnn before
% using it to predict the 55 for t_test
% it takes like 25 hours to do so
% after adjusting the ratings of 10% of train users
% the result rmse = 4.3407

% conclusion
% by adjusting the training set (before estimating the train+test)
% we got slightly better performance: rmse = 4.3400

clc;

% % load data
% load('Data\t_train.mat');
% load('Data\t_truth.mat');
% load('Data\t_test55.mat');
% load('Data\t_trainKnn.mat');
% 
% % loop on the t_trainKnn
% % check if each user has correlation with at leat 10
% % if so, re-do the estimating (using matrix completiton) with
% % only those correlated users
% 
% % calcuate the correlation
% corrs = corr(t_trainKnn', t_trainKnn', 'type', 'pearson');

% trainCorr = [];
% t_trainKnnAdj = t_trainKnn;
% for i=1:size(t_trainKnn,1)
%     uIdx = find(corrs(i,:) > 0.67);
%     uCount = length(uIdx);
%     disp(strcat('User: ', num2str(i), ', Cluster: ', num2str(uCount)));
%     % if w've enough train users correlated to the current test
%     % the add the current test to them and do prediction
%     if (uCount >= 10)       
%         trainCorr = [trainCorr, i];
%         % do prediction only on 10 train users
%         uTrain = t_train(uIdx(1:10),:);
%         mu = 0.001;
%         t_trainKnnAdj(i,:) = dataPrediction(uTrain, t_train(i,:),[], [99], mu);
%     end
% end

% we can't use t_testKnn because it's the same as the truth
% but we can use testAvg istead of it
t_test99 = averageCompletion(t_test55, [99]);

% estimating using Knn
estm99 = [t_trainKnnAdj; t_test99];
 
% estimate the 55 for test using matrix completiton
estm = dataCompletion(estm99, [55]);
 
% split train and test
offsetTr = size(t_train,1);
offsetTs = offsetTr + 1;
train99 = estm99(1:offsetTr,:);
test99 = estm99(offsetTs:end,:);

% get only the estimate of the test
estm =  estm(offsetTs:end,:);

[~, rmse, ~] = calcError(t_truth, t_test55, estm,[55 99]);
rmse









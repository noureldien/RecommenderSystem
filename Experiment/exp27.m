% like experiment 26 except using
% t_trainKnn+t_testAvg instead of t_trainAverage

clc;

%% experiment

% load data
load('Data\t_train.mat');
load('Data\t_truth.mat');
load('Data\t_test55.mat');
load('Data\t_trainKnn.mat');

% we can't use t_testKnn because it's the same as the truth
% but we can use testAvg istead of it
t_test99 = averageCompletion(t_test55, [99]);

% estimating using Knn
estm99 = [t_trainKnn; t_test99];

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

return;

% % calcuate the correlation
%corrs = corr(train99', estm', 'type', 'pearson');

% loop on the estimated test data
% check if each user has correlation with at leat 10 from train
% if so, re-do the estimating (using matrix completiton) with
% only those correlated users

testCorr = [];
estmAdj = estm;
for i=1:size(estm,1)    
    uIdx = find(corrs(i,:) > 0.65);    
    uCount = length(uIdx);
    disp(strcat('User: ', num2str(i), ', Cluster: ', num2str(uCount)));
    % if w've enough train users correlated to the current test
    % the add the current test to them and do prediction
    if (uCount > 5)
        testCorr = [testCorr, i];
        uTrain = train99(uIdx,:);
        estmAdj(i,:) = dataPrediction(uTrain, t_test55(i,:),[], [55 99]);
    end
end

[~, rmse, ~] = calcError(t_truth, t_test55, estm,[55 99]);
rmse

[~, rmseAdj, ~] = calcError(t_truth, t_test55, estmAdj,[55 99]);
rmseAdj


%% anaylsis for the experiment

% load data
% load('Data\t_train.mat');
% load('Data\t_truth.mat');
% load('Data\t_test55.mat');
% load('Data\trainAvg.mat');

%train99 = averageCompletion(t_train, [99]);
%trainVars = dataVariances(train99', []);
%[sortVars, sortIdx] = sort(trainVars, 'descend');

%trainAvg_ = trainAvg(1:10000,:);

% % get correlation coefficients
% distances = pdist2(trainAvg_, trainAvg_);
% pearsonCorr = corr(trainAvg_', trainAvg_', 'type', 'pearson');
% featureCorr = corr(trainAvg_, trainAvg_, 'type', 'pearson');

% users = [];
% for i=1:size(trainAvg_,1)
%     uIdx = find(pearsonCorr(i,:) > 0.65);
%     if  (length(uIdx)>10)
%         users = [users, i];
%     end
% end

%uIdx1 = find(distances(u,:)<46.7);
%uIdx2 = find(pearsonCorr(u,:)>0.58);
%uIdx = intersect(uIdx1, uIdx2);

% u = users(1002);
% uIdx = find(pearsonCorr(u,:)>0.65);
% 
% colormap = lines(length(uIdx));
% for i=1:size(colormap,1)
%     figure(1);clf;
%     hold on;
%     grid on;
%     box on;
%     plot(trainAvg_(uIdx(i),:), 'o', 'MarkerFaceColor',colormap(i,:), 'Color', 'w', 'MarkerSize', 8, 'LineWidth', 2);
%     pause(1.0);
% end










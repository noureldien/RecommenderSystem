% we use the estimated users we got in exp 20
% but instead of submitting the results, one more tweak to do
% for teach user in the estimated test, try find the nearest
% center of a clustered users. Then if this custer has at least
% 10 users associated with it, then do matrix completition
% on these 10 users + the test user to predict the 55 for the test user

clc;

% % load data
% load('Data\train.mat');
% load('Data\test.mat');
% load('Data\estm.mat');
% load('Data\trainCluster.mat');
% load('Data\trainClusterIdx.mat');
%
% data = [train; test];
%
% % complete 99 using average and 55 using matrix completion
% estm99 = averageCompletion(data, [99]);
%
% instead of expensive computation, just load it
% estm = dataCompletion(estm99, [55]);
%
% offset = size(estm99,1) + 1 - size(test,1);
% test99 = estm99(offset:end,:);
% train99 = estm99(1:size(train,1),:);

% get distances between each user
% distances = pdist2(test99, trainCluster);

estmAdj = estm;

% for each test
for i=1:size(distances,1)    
    % get the cluster with the nearest distance
    [minD, minIdx] = sort(distances(i,:));
    % get the indeces of train users associated with this cluster
    cIdx1 = find(trainClusterIdx == minIdx(1));
    cIdx2 = find(trainClusterIdx == minIdx(2));
    cIdx = [cIdx1; cIdx2];
    
    % now if the number of these users is big enough (> 10)
    % do matrix completiton these users + the current test
    % to predict the 55 from the current test
    cn = length(cIdx);    
    disp(strcat('User:', num2str(i), ', Count:', num2str(cn)));
    if (cn>=10)
        cTrain = train99(cIdx,:);
        estmAdj(i,:) = dataPrediction(cTrain, test99(i,:),[], [55]);
    end   
end

% nCluster = size(trainCluster, 1);
% count = [];
% for i=1:nCluster
%     clusterIdx = find(trainClusterIdx(trainClusterIdx == i));
%     %count =
% end

% save the results
saveResult(test, estmAdj, 39);








% this analysis shows that users with high variance in their
% ratings, the matrix completion fails to predict their ratings correctly
% so we'll re adjust their rating by not the average but the average 
% of 2 clusters of their ratings

clc;

% load data
load('Data\train.mat');
load('Data\test.mat');
load('Data\estm.mat');
load('Data\trainCluster.mat');
load('Data\trainClusterIdx.mat');

a = 56;
testAvg = averageCompletion(test,[55 99]);

higVarThr = 44.1;
lowVarThr = 400;

% get the 55 estimates for low/high variance users
u1 = test99(varIdx(a),:);
u2 = test99(varIdx(mTest-a),:);
estmU1 = estm(varIdx(a),:);
estmIdxU1 = find(u1==55);
estmU1 = estmU1(estmIdxU1);
estmU2 = estm(varIdx(mTest-a),:);
estmIdxU2 = find(u2==55);
estmU2 = estmU2(estmIdxU2);
u1 = u1(u1~=55);
u2 = u2(u2~=55);

% for users with high variance, what we'll try to do is estimate
% 2 clusters (k-means) and set the ratings to the mean of the cluster
% that has more ratings
% for example we have user with high variance, his ratings are
% mainly +9 and -8. So we learn k-means and let's suppose that
% the number of ratings close to +9 are more than those close to -8
% then put the user ratings to +9

highVarIdx = find(testVar>higVarThr);
uKm = zeros(1, length(highVarIdx));
for i=1:length(highVarIdx)
    % get the user ratings without 55
    % test 99 train+test got 99 estimated by averaging, then cut
    % the lower part as test99
    u = test99(highVarIdx(i),:);
    u = u(u~=55);
    %learn k-means
    [kmIdx, kmC] = kmeans(u', 2);
    if ( length(find(kmIdx==1)) > length(find(kmIdx==2)))
        uKm(i) = kmC(1);
    else
        uKm(i) = kmC(2);
    end
    break;
end

% get the average ratings for each feature
estmIdx = [estmIdxU1 estmIdxU2];
featureAvg = zeros(1, length(estmIdx));
for i=1:length(estmIdx)
    featureAvg(i) = mean(testAvg(:,estmIdx(i)));
end

figure(1);clf;
hold on;
grid on;
box on;
plot(u1, 'o', 'MarkerFaceColor','r', 'Color', 'w', 'MarkerSize', 5);
plot(u2, 'o', 'MarkerFaceColor','b', 'Color', 'w', 'MarkerSize', 5);
plot(estmIdxU1, estmU1, 'o', 'MarkerFaceColor','r', 'Color', 'k', 'MarkerSize', 10, 'LineWidth', 2);
plot(estmIdxU2, estmU2, 'o', 'MarkerFaceColor','b', 'Color', 'k', 'MarkerSize', 10, 'LineWidth', 2);
plot(estmIdx, featureAvg, 'o', 'MarkerFaceColor','w', 'Color', 'k', 'MarkerSize', 10, 'LineWidth', 2);
plot(estmIdxU1, uKm(1), 'o', 'MarkerFaceColor','g', 'Color', 'k', 'MarkerSize', 10, 'LineWidth', 2);
legend('Low Var User U1', 'High Var User U2', 'Estm for U1', 'Estm for U2', 'Feature Avg');
%plot(u2, '.b', 'LineWidth', 12);
%plot(u1, '.r', 'LineWidth', 12);




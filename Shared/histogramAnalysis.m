% doing some analysis on the histograms of the ratings
% for each feature

clc;

% include directories
addpath(genpath('./Data/'));
addpath(genpath('./Shared/'));

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');
load('Data\fourk.mat');
load('Data\fourk55.mat');
load('Data\train.mat');
load('Data\test.mat');

% the matrix is M x N
% m is the users, n is the jokes
% all the analysis will be done on small space (2D)
% then later on, it will be scaled up to the full space (100D)
M   = 6000;
N   = 100;
[M,N] = size(t_truth);

% take small portion of the data
t_train = t_train(1:M,1:N);
t_test = t_test(1:M,1:N);
t_truth = t_truth(1:M,1:N);

ratings = -10:10;
dataHistoTrain = featuresHistogram(train, [55 99]);
dataHistoTest = featuresHistogram(test, [55 99]);

% now we want to cluster the jokes based on their histograms
% as the histogram is considered the feature descriptor
% using k-means, varying k tell we found something good
% number of clusters = 18 is chosen upon some analysis too!
K = 18;
[kmIdxTrain, kmCTrain] = kmeans(dataHistoTrain, K);
[kmIdxTest, kmCTest] = kmeans(dataHistoTest, K);

return;

%% plot all the histograms in one graph
% % the histograms are color-coded according to the center of k-means
% colormap = lines(K);
% figure(1); clf;
% subplot(1,2,1);
% hold on;
% grid on;
% box on;
% for i=1:N
%     plot(ratings, dataHistoTrain(i,:), 'LineWidth', 1, 'Color', colormap(kmIdxTrain(i),:));
% end
% title(strcat(num2str(K),'-mean clustering on histo of jokes'' ratings - training'));
% 
% subplot(1,2,2);
% hold on;
% grid on;
% box on;
% for i=1:N
%     plot(ratings, dataHistoTest(i,:), 'LineWidth', 1, 'Color', colormap(kmIdxTrain(i),:));
% end
% title(strcat(num2str(K),'-mean clustering on histo of jokes'' ratings - test'));
%
%return;

%% plot the 100 histograms for the features
%colormap = lines(100);
% for i=1:100
%     fig = figure(1); clf;
%     hold on;
%     grid on;
%     box on;
%     histo = dataHistoTrain(i,:);
%     histo = histo/norm(histo,2);
%     plot(ratings, histo, 'LineWidth', 3, 'Color', colormap(i,:));
%     histo = dataHistoTest(i,:);
%     histo = histo/norm(histo,2);
%     axis([-10,10,0,0.4])
%     plot(ratings, histo, 'LineWidth', 1, 'Color', colormap(i,:));
%     xlabel('User ratings form -10 to 10');
%     ylabel('Number of users (normalised)');
%     title(strcat('Histogram of ratings for joke:', num2str(i)));
%     legend('train', 'test');
%     %saveas(fig, strcat('./histo/histo_', num2str(i), '.png'));
%     %pause(0.5);
% end

%% some analysis to choose the right cluster number by measuring emse
% to make sure this is the right k for clustering, we've to
% calcute the error rmse
% nHisto = size(dataHistoTrain,1);
% e1 = [];
% e2 = [];
% e3 = [];
% ks = 5:50;
% 
% for i=1:length(ks)
%     K = ks(i);
%     [kmIdxTrain, kmCTrain] = kmeans(dataHistoTrain, K);
%     [kmIdxTest, kmCTest] = kmeans(dataHistoTest, K);
%     rmseTrain = zeros(1, nHisto);
%     rmseTest = zeros(1, nHisto);
%     rmseTest_ = zeros(1, nHisto);
%     for j=1:nHisto
%         kmCenter = normalize(kmCTrain(kmIdxTrain(j),:));
%         kmCenter_ = normalize(kmCTest(kmIdxTest(j),:));
%         rmseTrain(j) = norm(normalize(dataHistoTrain(j,:)) - kmCenter);
%         rmseTest(j) = norm(normalize(dataHistoTest(j,:)) - kmCenter);
%         rmseTest_(j) = norm(normalize(dataHistoTest(j,:)) - kmCenter_);
%     end
%     rmseTrain = sqrt(mean((rmseTrain).^2));
%     rmseTest = sqrt(mean((rmseTest).^2));
%     rmseTest_ = sqrt(mean((rmseTest_).^2));
%     e1 = [e1, rmseTrain];
%     e2 = [e2, rmseTest];
%     e3 = [e3, rmseTest_];
% end
% 
% figure(1); clf;
% hold on;
% grid on;
% box on;
% plot(ks, e1, 'r');
% plot(ks, e2, 'b');
% plot(ks, e3, 'k');
% xlabel('Number of means (i.e clusters)');
% ylabel('Error (RMSE)');
% title('Choosing the right/reasonable number of cluster');
% legend('RMSE training using training means', 'RMSE test using training means', 'RMSE test using test means');














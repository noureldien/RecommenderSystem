% this is some analysis done over the features
% using correlation coefficient (linear correlation)

% conclusion, the whole approach is utterly wrong
% this point is wrong: depending on correlation coffeicient
% as an index in correlation between 2 features

%% the algorithm

clc;

% include directories
addpath(genpath('..\Data\'));
addpath(genpath('..\Shared\'));

% load the data
load('Data\t_train.mat');
load('Data\t_test.mat');
load('Data\t_truth.mat');
% load('..\Data\fourk.mat');
% load('..\Data\fourk55.mat');
% load('..\Data\train.mat');
% load('..\Data\test.mat');

data = t_truth;
[M,N] = size(data);

% get correlation coefficients
coeffs = corrcoef(data);

% get the variances of the feature, at the end of the algorithm
% a feature is not clustered, check it's variance, if it has
% hight variance, then it's a noisy feature, neglect it
% on the other hand, if it has low variance, then it's a good
% discrimanent feature, add it to it's own cluster
vars = dataVariances(data, [99 55]);

% threshold under it, the 2 features are not considered correlated
corrThreshold = 0.3;

% variance threshold, a feature with variance over it
% is considered noisy and not picked up in the cluster
varThreshold = 33;

% represents the clusters of correlated features
% each row represnet a cluster, which contains
% the index of correlated features
clusters = {};

% loop on the coeffs of the features
for i=1:N
    
    isCorrelated = false;
    
    % loop on the clusters of features
    for j=1:size(clusters,1)
        
        % loop each the features in the current cluster
        for k=1:size(clusters,2)
            
            % the id of the feature in the current cluster
            clusteredFeatureID = clusters{j,k};
            
            % check the correlation between the current feature
            % and the clustered feature is above threshold
            if (coeffs(clusteredFeatureID,i) >= corrThreshold)
                isCorrelated = true;
            else
                % if only one clustered feature is not correlated
                % with the current feature, then the current feature
                % is not correlated with all the cluster
                isCorrelated = false;
                break;
            end
        end
        
        % break if correlation is found
        if (isCorrelated)
            break;
        end
        
    end
    
    % now, if there is correlation
    % then add the feature to the cluster
    if (isCorrelated)
        clusters{j,:} = [clusters{j,:} i];
    else
        % if no correlation is found, then check if
        % the feature is noisy or not, by checking it's variance
        % if it is noisy, then add it in a new cluster
        if (vars(i) <= varThreshold)
            clusters = [clusters; i];
        end
    end
    
end

%% how to decide the coeffThreshold
% test the result of the clustering, this is how
% to check if we choosed the correct cluster or not

%% visualizing the clustered (correlated) features
% % 2,16,75
% % 11,12,14
% f1 = data(:,12);
% f2 = data(:,14);
% 
% histos = featuresHistogram([f1 f2], [55 99]);
% rates = -10:10;
% 
% figure(1);clf;
% fig = figure(1);clf;
% subplot(2,2,1);
% axis([0 500 -10 10]);
% hold on;
% grid on;
% box on;
% barh(rates, histos(1,:));
% subplot(2,2,2);
% axis([0 500 -10 10]);
% hold on;
% grid on;
% box on;
% barh(rates, histos(2,:));
% subplot(2,2,3);
% hold on;
% grid on;
% box on;
% plot(f1, f2, '.');
% f1_ = sort(f1);
% f2_ = sort(f2);
% plot(f1_, f2_, '.r');
% disp(sqrt(mean((f1-f2).^2)));

%% how to decide the varThreshold
% this value decides if a feature is noisy or not
% the following is the anaylsis to pick up the correct value
% histos = featuresHistogram(data, [55 99]);
% rates = -10:10;
% for z=1:length(vars)
%     if (vars(z) > varThreshold)
%         fig = figure(z);clf;
%         set(fig, 'Position', [150 150 1000 500]);
%         subplot(1,2,1);
%         axis([0 500 -10 10]);
%         hold on;
%         grid on;
%         box on;
%         barh(rates, histos(z,:)');
%         title(strcat('Feature:', num2str(z)));
%         hold on;
%         grid on;
%         box on;
%         subplot(1,2,2);
%         plot(data(:,z), '.');
%         title(strcat('Feature:', num2str(z)));
%     end
% end











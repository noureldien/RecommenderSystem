clc;

load('data\train.mat');
load('data\test.mat');

indexes = [];
ratings = [];

[train_h,train_w] = size(trainset);
colum_data = [];

for i=1:10
    
    % remove samples with missing rating
    %indexes = find(trainset(:,i) == 99);
    %colum_data = trainset(:,i);
    %colum_data(indexes) = [];
    
    figure (i); clf;
    boxplot(colum_data);
end

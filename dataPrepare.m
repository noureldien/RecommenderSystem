% we have original train and test data
% around ~6K rows are complete and ~15k rows have missing values (99)
% we'll take the train and split it to two parts
% t_train: have the ~15K
% t_truth: have the ~6K
% t_test: have the ~6K but after removing some data from it (around
% 40% of the data)

% how any model will work
% we'll train the model on t_train, then test it on t_test
% then check(validation/generalisation) the test_results against
% the t_truth

clc;

%% step one

% % load the data
% load('Data\train.mat');
% load('Data\test.mat');
% 
% t_train = [];
% t_truth = [];
% 
% missingValue = 99;
% 
% for i=1: length(train)
%     if (ismember(missingValue, train(i,:)))
%         t_train = [t_train; train(i,:)];
%     else
%         t_truth = [t_truth; train(i,:)];
%     end
% end
% 
% % save the data
% save('Data\t_train.mat', 't_train');
% save('Data\t_truth.mat', 't_truth');
% 
% disp('Finish Step One');

%% step two

% % load the truth
% load('Data\t_truth.mat');
% 
% % from the t_truth, generate the t_test by
% % removing some values from the matrix (~40%) by 99
% % and save this to new matrix t_test
% 
% [N, M] = size(t_truth);
% t_test = zeros(N, M);
% 
% missingValue = 99;
% missingRatio = 40/100;
% missingRatio = missingRatio * M;
% 
% for i=1:N
%     idx = randperm(M, missingRatio);
%     t_test(i,:) = t_truth(i,:);
%     t_test(i,idx) = missingValue;
% end
% 
% % save the data
% save('Data\t_test.mat', 't_test');
% 
% disp('Finish Step Two');













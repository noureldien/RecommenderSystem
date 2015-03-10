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
% 
% missingValue = 99;
% missingRatio = 40/100;
% missingRatio = missingRatio * M;
%
%t_test = t_truth;
% 
% for i=1:N
%     idx = randperm(M, missingRatio);
%     t_test(i,idx) = missingValue;
% end
% 
% % save the data
% save('Data\t_test.mat', 't_test');
% 
% disp('Finish Step Two');

%% step three

% % load the t_test
% load('Data\t_test.mat');
% 
% % from the t_test, generate the t_test55 by
% % removing 3 non-99 values from the matrix
% % and save this to new matrix t_test55
% 
% [N, M] = size(t_test);
% 
% avoidedValued = 99;
% missingValue = 55;
% missingRatio = 3;
% 
% t_test55 = t_test;
% 
% for i=1:N
%     idx = find(t_test(i,:)~=99);
%     idx = randperm(length(idx), missingRatio);
%     t_test55(i,idx) = missingValue;
% end
% 
% % save the data
% save('Data\t_test.mat55', 't_test55');
% 
% disp('Finish Step Three');

%% step four
% get t_trainKnn and t_testKnn from traintestKnn

% load('Data\train.mat');
% load('Data\traintestKnn.mat');
% 
% %first, get the trainKnn
% trainKnn = traintestKnn(1:size(train,1),:);
% 
% %for each row in the train, if this row does not have empty
% %then with this index, fill the t_trainKnn
% t_trainKnn = [];
% t_testKnn = [];
% for i=1:size(trainKnn,1)
%     i
%     idx = find(train(i,:)==99);
%     if (isempty(idx))
%         t_testKnn = [t_testKnn; trainKnn(i,:)];
%     else
%         t_trainKnn = [t_trainKnn; trainKnn(i,:)];        
%     end 
% end
% 
% % save the data
% save('Data\t_testKnn.mat', 't_testKnn');
% save('Data\t_trainKnn.mat', 't_trainKnn');

%disp('Finish Step Four');

% %% step five
% 
% % add three missing data (77) for each user
% % in the test data, this is the only way we can create
% % a ground truth for the actual test set
% 
% % load data
% load('Data\test.mat');
% % 
% % from the test, generate the test77 by
% % removing 3 non-99-non-55 values from the matrix
% % and save this to new matrix test77
% 
% [N, M] = size(test);
% 
% missingCount = 3;
% test77 = test;
% 
% for i=1:N
%     idx = find(test(i,:)~=99 & test(i,:)~=55);
%     idx = randperm(length(idx), missingCount);
%     test77(i,idx) = 77;
% end
%  
% % save the data
% save('Data\test77.mat', 'test77');
%  
% disp('Finish Step Five');
















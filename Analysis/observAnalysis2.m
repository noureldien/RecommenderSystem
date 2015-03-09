% this analysis is done over the test users
% to see if we've that kind of noisy users or not

offset = 300;
user1 = data(idxSort(offset),:);
user2 = data(idxSort(N-offset),:);

figure(1);clf;
hold on;
plot(user1);
plot(user2);
return;

% load data
load('Data\test.mat');

% complete the data really quick by averaging
data = averageCompletion(test,[55 99]);

% check variances of users
vars = dataVariances(data', []);
[varsSort, idxSort] = sort(vars);

N = length(idxSort);

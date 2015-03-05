% old code, might be needed in the future


%% this is to see if the test and train data are correlated or not.
% figure(1); clf;
% hold on;
% box on;
% grid on;
% plot(dataVariances(train, [55 99]), 'k', 'LineWidth', 5);
% plot(dataVariances(test, [55 99]), 'b', 'LineWidth', 3);
% legend('train', 'test');
% title('Variances of train and test.');
% %plot(dataVariances(t_test, [55 99]), 'g', 'LineWidth', 4);
% %plot(dataVariances(fourk, [55 99]), 'b', 'LineWidth', 3);
% %plot(dataVariances(fourk55, [55 99]), 'r', 'LineWidth', 1);
% return;

%% this is how to do permutation for data
%x = 1:20;
%N = length(x); 
%perm_idx = randperm(N);
%x_perm = zeros(1, N);
%
% permute
%for i=1:N
%    x_perm(i) = x(perm_idx(i));
%end
%
% return back original result
%x_recvd = zeros(1, N);
%for i=1:N
%    x_recvd(perm_idx(i)) = x_perm(i);
%end
%
%disp(x);
%disp(x_perm);
%disp(x_recvd);
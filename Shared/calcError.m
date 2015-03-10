function [ confusion, rmse, ame ] = calcError(t_truth, t_test, t_estm, missings)
% calcuate error
% INPUT:
%     t_truth : the ground-truth matrix
%     t_train : the matrix used in testing
%     t_estm  : the matrix estimated (predicted)
%     missing : the number used to represent a missing rating
% OUTPUT:
%     the confusionMatrix and RMSE

% we only interested in the ratings that were missing
% and was predicting, we're not going to calculate the error
% for all the ratings
K = length(missings);
idx = [];
for j=1:K
    idx = [idx; find(t_test == missings(j))];
end

rmse = abs(t_truth(idx) - t_estm(idx))';
rmse = reshape(rmse,[size(rmse,1)*size(rmse,2),1]);
ame = mean(rmse);
rmse = sqrt(mean((rmse).^2));

confusion = abs(t_truth - t_estm)';

end


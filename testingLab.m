%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% place where you test cool stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[~, rmse, ~] = calcError(t_truth, t_test55, estm,[55 99]);
rmse

[~, rmseAdj, ~] = calcError(t_truth, t_test55, estmAdj,[55 99]);
rmseAdj







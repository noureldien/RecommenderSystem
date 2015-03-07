% one step is using the estimated test, place 55 in it
% and estimate 55
test55 = estmTestRecov;
test55(test==55) = 55;
estmTest55 = dataCompletion(test55, [55]);

% save the results
saveResult(test, estmTestRecov, 20);
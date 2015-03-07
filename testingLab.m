% get the errors
[~, rmseEstm, ~] = calcError(fourk, fourk55, estm55, [55]);
disp(rmseEstm);
% this was 4.02

% get the errors
[~, rmseEstm, ~] = calcError(fourk, fourk55, estm, [55]);
disp(rmseEstm);
% this was 3.99
clc;

% % save the result
% result = zeros(M,4);
% M = 3000;
% for i=1:M
%     idx = find(test_(i,:) == 55);
%     result(i,:) = [i, estm_(i,idx)];
% end
% 
% result(result > 10) = 10;
% result(result < -10) = -10;
% 
% for i=1:M
%     result(i,1) = i;
% end
% 
% csvwrite('./Submission/submission_003.csv',result, 1, 0);

%%%%%%%%%%%%%%%%%%%%%%%
% Use this only if you're using train+test as one big matrix
% for training your model
%%%%%%%%%%%%%%%%%%%%%%%

offset = size(estm,1) + 1 - 3000;
test_ =  test(offset:end,:);
estimated = estm(offset:end,:);

% save the result
M = 3000;
result = zeros(M,4);
for i=1:M
    idx = find(test_(i,:) == 55);
    result(i,:) = [i, estimated(i,idx)];
end

result(result > 10) = 10;
result(result < -10) = -10;

for i=1:M
    result(i,1) = i;
end

csvwrite('./Submission/submission_004.csv',result, 1, 0);
return;









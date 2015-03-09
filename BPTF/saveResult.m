function [result] = saveResult( data, estm, fileID )

% extract the predicted values and save it in an scv file
%
% INPUT:
%    data : the data used in the training
%    estm : the result of the esmtimate
%  fileID : the id of the file to save data to
%
% OUTPUT:
%  result : the result matrix that was saved in the submission file

% extract the predicted values and save it in an scv file
offset = size(estm,1) + 1 - 3000;
data =  data(offset:end,:);
estm = estm(offset:end,:);

% save the result
M = 3000;
result = zeros(M,4);
for i=1:M
    idx = find(data(i,:) == 55);
    result(i,:) = [i, estm(i,idx)];
end

% make sure upper and lower bounds are okay
result(result > 10) = 10;
result(result < -10) = -10;

for i=1:M
    result(i,1) = i;
end

fileName = strcat('./submission_0', num2str(fileID), '.csv');

% write header
header = 'UserId,Rating1,Rating2,Rating3\n';
fileID = fopen(fileName,'w');
fprintf(fileID, header);
fclose(fileID);

% append results
dlmwrite(fileName, result, 'delimiter', ',', '-append');


end
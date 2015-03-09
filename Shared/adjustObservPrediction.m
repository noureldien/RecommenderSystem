function [adjEstm] = adjustObservPrediction(test, estm, estm99)

% imperical adjustment for ratings of observations with high variance
%
% INPUT: 
%           test : test set (with 99 and 55)
%           estm : final estimate of test set (55, 99 estimated by Matrix Completiton)
%         estm99 : the train+test having 99 estimated by avaraging
% OUTPUT:
%        adjEstm : new estimate after doing the final adjustment

% for users with high variance, learn 2 clusters (k-means) and
% set the ratings to the center of the cluster that has more ratings
% for example we have user with high variance, with ratings are
% mainly +9 and -8. So we learn k-means and let's suppose that
% the number of ratings close to +9 are more than those close to -8
% then put the user ratings to +9

% above this variance threshold, a user is considered
% high-variance user

varThr = 42;

%testAvg = averageCompletion(test,[55 99]);
%testAvg = averageCompletion(test,[55 99]);
% estm =  estm(offset:end,:);
% test99 = estm99(offset:end,:);

offset = size(estm99,1) + 1 - size(test,1);
test99 = estm99(offset:end,:);

adjEstm =  estm;


% get the variances
testVar = dataVariances(test99',[55]);

uIdx = find(testVar>varThr);
for i=1:length(uIdx)
    % get the user ratings without 55
    u99 = test99(uIdx(i),:);
    u = u99(u99~=55);
    %learn k-means
    [kmIdx, kmC] = kmeans(u', 2);
    if ( length(find(kmIdx==1)) > length(find(kmIdx==2)))
        uKm = kmC(1);
    else
        uKm = kmC(2);
    end
    
    % now place the new estimates in the same place of 55
    % get where 55 are and place the mean in it
    adjU = adjEstm(uIdx(i),:);
    fIdx = find(u99==55);
    for j=1:length(fIdx)
       adjU(fIdx(j)) = mean(estm(:,fIdx(j)));
    end    
    adjEstm(uIdx(i),:) = adjU;
end

end
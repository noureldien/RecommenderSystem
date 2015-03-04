function [data] = normalize(data)
% normlaize the given array of vectors

for i=1:size(data,1)
    v = data(i,:);
    data(i,:) = v/norm(v,2);
end
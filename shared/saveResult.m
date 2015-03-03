% save the result
result = zeros(M,4);
for i=1:M
    idx = find(test(i,:) == 55);
    result(i,:) = [i, estm(i,idx)];
end

result(result > 10) = 10;
result(result < -10) = -10;

for i=1:M
    result(i,1) = i;
end

csvwrite('./Data/Result.csv',result, 1, 0);

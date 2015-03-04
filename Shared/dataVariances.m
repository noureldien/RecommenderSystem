function [variances] = dataVariances(data, missings)
% return the variances of the given data
% it is helpful specially when the data contains missing value

[M,N] = size(data);
K = length(missings);

variances = zeros(1,N);

for i=1:N
    feature = data(:,i);
    for j=1:K
        feature = feature(feature ~= missings(j));
    end
    variances(i) = var(feature);
end

end







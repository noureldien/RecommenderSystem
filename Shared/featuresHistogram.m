function [histograms] = featuresHistogram(data, missings)
% return the histogram for the given features of the data
% input:
%           data: M*N where M are the observations, N are the features
% output:
%           histograms: N*21 where N is the number of features
%                       and 21 is because we've ratings from -10 to 10
%                       i.e we've 21 levels of ratings

[M, N] = size(data);
K = length(missings);
nBins = 21;
bins = -10:10;

histograms = zeros(N,nBins);

for i=1:N
    
    % sanitize the data of the feature first
    % i.e. remove the missings
    feature = data(:,i);
    for j=1:K
        feature = feature(feature ~= missings(j));
    end
    % round the ratings to the nearest int values
    % so we can draw a histogram
    feature = double(int16(feature));
    
    % get the histogram
    for j=1:nBins
        histograms(i,j) = length(feature(feature == bins(j)));
    end
    
    % other in-acurate ways
    %[feature_histo1, ~] = hist(feature, nBins);
    %feature_histo2 = histcounts(feature, 21);
    
end
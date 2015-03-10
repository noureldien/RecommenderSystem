function res = averageCompletion(m,v)

% Fills the matrix using the averages of lines and columns

[nbUsers,nbMovies] = size(m);
res = m;

avgMovies = eye(1,nbMovies);
avgOffsets = eye(1,nbUsers);

varMovies = eye(1,nbMovies);
varOffsets = eye(1,nbUsers);

m(m>10 | m<-10) = NaN;

%Calculate the average rating per movie and its variance
for j=1:nbMovies
    avgMovies(j) = nanmean(m(:,j));
    varMovies(j) = nanvar(m(:,j));
end
totAvgMovies = mean(avgMovies);
totVarMovies = mean(varMovies);

%Calibrate the variance of this particular movie wrt the others
K = varMovies/totVarMovies;

%Recalculate the average by considering the observations as taken from a
%distribution, using the variance
for j=1:nbMovies
    tot = 0;
    nbRated = 0;
    for i=1:nbUsers
        if not (isnan(m(i,j)))
            tot = tot + m(i,j);
            nbRated = nbRated + 1;
        end
    end
    avgMovies(j) = (totAvgMovies*K(j) + tot)/(K(j) + nbRated);
end

%Calculate the average offset per user
%for each movie the user rated : difference between average of that movie
%and the user's rating
%then average of that to give one value per user
for i=1:nbUsers
    avgOffsets(i) = nanmean(m(i,:) - avgMovies);
    varOffsets(i) = nanvar(m(i,:) - avgMovies);
end
totAvgOffsets = mean(avgOffsets);
totVarOffsets = mean(varOffsets);

%Calibrate the variance of this particular offset wrt the others
K = varOffsets/totVarOffsets;

%Recalculate the average by considering the observations as taken from a
%distribution, using the variance
for i=1:nbUsers
    tot = 0;
    nbRated = 0;
    for j=1:nbMovies
        if not (isnan(m(i,j)))
            offset = m(i,j) - avgMovies(j);
            tot = tot + offset;
            nbRated = nbRated + 1;
        end
    end
    avgOffsets(i) = (totAvgOffsets*K + tot)/(K + nbRated);
end

nv = length(v);

%Filling the matrix
for i=1:nbUsers
    for j=1:nbMovies
        for k=1:nv
            if (res(i,j) == v(k))
                res(i,j) = avgMovies(j) + avgOffsets(i);
                break;
            end
        end
    end
end

end
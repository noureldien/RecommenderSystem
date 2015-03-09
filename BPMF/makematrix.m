% Create a matrix of size num_p by num_m from triplets {user_id, movie_id, rating_id}
load moviedata

num_m = 3952;
num_p = 6040;
%for Netflida data, use sparse matrix instead.
count = zeros(num_p,num_m,'single');

for mm=1:num_m
 ff= find(train_vec(:,2)==mm);
 count(train_vec(ff,1),mm) = train_vec(ff,3);
end
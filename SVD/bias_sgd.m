
function [bi, bu]=bias_sgd(train_data,X,bu,bi,g_mean,lambda_b)
rate=0.001;

N=size(train_data,1);

perm = randperm(N);
    
    for n=1:N
        
        user = train_data(perm(n),1);
        movie = train_data(perm(n),2);
        rating = train_data(perm(n),3);
            
        bu_grad=-2 * (rating - X(user,movie)-bi(1,movie)-bu(user,1)-g_mean) +2*lambda_b*bu(user,1);
        bu(user,1)=bu(user,1)-rate*bu_grad;
        
        bi_grad=-2 * (rating - X(user,movie)-bi(1,movie)-bu(user,1)-g_mean) +2*lambda_b*bi(1,movie);
        bi(1,movie)=bi(1,movie)-rate*bi_grad;
        
           
    end
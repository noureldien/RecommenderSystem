• train: the given training set from kaggle
• test: the given test set form kaggle

• fourk: small sample of the train to do experiments (in fast way)
• fourk55: it is the fourk with missing 55. So fourk is considered a ground_truth for fourk55

• t_train: it's the observations from train that has missing values
• t_truth: it's the observations from train that does NOT have missing values
• t_test: it's the t_truth with 55 missings introduced to it. So, we can consider t_truth
          as the groud truth

• trainKnn1,2: 1st and 2nd trials to predict the 99 from train using Knn
• traintestKnn: predicting 55, 99 from train and test using Knn
• trainAvg: predicting the 99 from train using averaging

• estm: the estimate of 99 and 55 for train+test using matrix completion
• estm_t_truth: the estimate of t_test using matrix completion done on t_train+t_test
# 1 -> simulate some genetic data  for 10,000 indiviuals and 10,000 snps (using the function --make-snps)
./ldak5.2.linux --make-snps simulation/sample/data  \
                --num-samples 10000 --num-snps 10000

# 2 - simulate some phenotypes (using the function --make-phenos)
# power -> how predictors are scaled
# her -> he proportion of total phenotypic variation explained by the genetic contribution /
#        how much of the variation in a given trait can be attributed to genetic variation.
# num-causals ->to specify the number of predictors contributing to each phenotype (to specify 
#               that all predictors are causal, use --num-causals -1) 
./ldak5.2.linux --make-phenos simulation/pheno/pheno \
                --bfile simulation/sample/data \
                --ignore-weights YES \
                --power -0.25 \
                --her 0.8 \
                --num-phenos 1 \
                --num-causals 1000 
                #--prevalence 0.5 -> for binary 

# 3 - divide the data into training and test (eg 90% and 10%)
head -n 9000 simulation/sample/data.fam > simulation/subsets/training.fam
head -n 9000 simulation/sample/data.bed > simulation/subsets/training.bed
head -n 9000 simulation/sample/data.bim > simulation/subsets/training.bim
tail -n 1000 simulation/sample/data.fam > simulation/subsets/test.fam
tail -n 1000 simulation/sample/data.bed > simulation/subsets/test.bed
tail -n 1000 simulation/sample/data.bim > simulation/subsets/test.bim

# linear -> one-predictor-at-a-time analysis 
./ldak5.2.linux --linear simulation/linreg/linreg \
                --bfile simulation/sample/data \
                --pheno simulation/pheno/pheno.pheno \
                --remove simulation/subsets/test.fam 

 
## calc-scores for training set
./ldak5.2.linux --calc-scores simulation/scores/scores \
                --scorefile simulation/linreg/linreg.score \
                --bfile simulation/sample/data \
                --pheno simulation/pheno/pheno.pheno \
                --power 0 \
                --remove simulation/subsets/test.fam

## compute the scores for the test sample
./ldak5.2.linux --calc-scores simulation/scores/test_scores \
                --scorefile simulation/linreg/linreg.score \
                --bfile simulation/sample/data \
                --power 0 \
                --pheno simulation/pheno/pheno.pheno \
                --remove simulation/subsets/training.fam


## which profile is more correlated with the real phenotype? 
## check simulation/scores/test_scores.cors
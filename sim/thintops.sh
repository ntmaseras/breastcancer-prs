## THINTOPS -> USED TO THIN ONLY SIGNIFICANT PREDICTORS
### THIN -> light thinning, no duplicates

# 1 -> simulate some genetic data  for 10,000 indiviuals and 10,000 snps (using the function --make-snps)
./ldak5.2.linux --make-snps simulation/sample/data  \
                --num-samples 10000 --num-snps 10000

# 2 - simulate some phenotypes (using the function --make-phenos)
# power -> how predictors are scaled
# her -> he proportion of total phenotypic variation explained by the genetic contribution
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


## thintops
p_values=("1" "0.1" "1e-2" "1e-3" "1e-4" "1e-5" "1e-6" "1e-7" "5e-8")

# Iterate over each p-value
for p in "${p_values[@]}"; do
    echo "Processing p-value: $p"

    # Thin the training data
    ./ldak5.2.linux --thin-tops simulation/thintops/filtered_SNPS$p \
                    --bfile simulation/sample/data \
                    --pvalues simulation/linreg/linreg.pvalues \
                    --cutoff $p \
                    --window-prune 0.1 \
                    --window-kb 1000 \
                    --remove simulation/subsets/test.fam 

    # compute scores for all SNPs (training data) extracting the thinSNPS-> prob not necessary, just using it for visualization
    ./ldak5.2.linux --calc-scores simulation/thintops_scores/train_scores$p \
                    --scorefile simulation/linreg/linreg.score \
                    --bfile simulation/sample/data \
                    --pheno simulation/pheno/pheno.pheno \
                    --extract simulation/thintops/filtered_SNPS$p.in \
                    --power 0 \
                    --remove simulation/subsets/test.fam 

    
    # compute the scores for the test sample for the filtered snps 
    ./ldak5.2.linux --calc-scores simulation/thintops_scores/test_scores$p \
                    --scorefile simulation/linreg/linreg.score \
                    --pheno simulation/pheno/pheno.pheno \
                    --bfile simulation/sample/data \
                    --power 0 \
                    --remove simulation/subsets/training.fam \
                    --extract simulation/thintops/filtered_SNPS$p.in 
           

done

python3 eval_thintops.py > results/eval_thintops_results.txt



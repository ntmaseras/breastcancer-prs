#https://dougspeed.com/megaprs/
#1. Calculate predictor-predictor correlations
./ldak5.2.linux --calc-cors megaprs/cors \
                --bfile simulation/sample/data \
                --window-kb 1000 \
                --remove simulation/subsets/test.fam 

##2. Construct the prediction model 
models=("lasso" "ridge" "bolt" "bayesr")

# Loop through each model type
for model in "${models[@]}"; do
    echo "Running for model: $model"
    
    mega_prs_dir="megaprs/$model/$model"

    ./ldak5.2.linux --mega-prs "$mega_prs_dir" \
                    --model "$model" \
                    --ind-hers simulation/taggings/sumhers.ind.hers \
                    --summary simulation/linreg/linreg.summaries \
                    --cors megaprs/cors \
                    --check-high-LD NO \
                    --cv-proportion .1 \
                    --window-kb 1000 \
                    --allow-ambiguous YES
                    
    ./ldak5.2.linux --calc-scores "megaprs/$model/train_scores"\
                    --scorefile "$mega_prs_dir.effects" \
                    --bfile simulation/sample/data \
                    --power 0 \
                    --pheno simulation/pheno/pheno.pheno \
                    --remove simulation/subsets/test.fam

    ./ldak5.2.linux --calc-scores "megaprs/$model/scores"\
                    --scorefile "$mega_prs_dir.effects" \
                    --bfile simulation/sample/data \
                    --power 0 \
                    --pheno simulation/pheno/pheno.pheno \
                    --remove simulation/subsets/training.fam

done

## if we had high ld predictors: ./ldak.out --cut-genes highld --bfile human --genefile highld.txt
##Prediction model in .effects     

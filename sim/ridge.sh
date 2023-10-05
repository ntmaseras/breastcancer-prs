./ldak5.2.linux --ridge ridge/ridge \
                --bfile simulation/sample/data \
                --pheno simulation/pheno/pheno.pheno \
                --ind-hers simulation/taggings/sumhers.ind.hers \
                --cv-proportion .1\
                --remove simulation/subsets/test.fam 

./ldak5.2.linux --calc-scores "ridge/scores_train" \
                --scorefile "ridge/ridge.effects" \
                --bfile simulation/sample/data \
                --power 0 \
                --pheno simulation/pheno/pheno.pheno \
                --remove simulation/subsets/test.fam

./ldak5.2.linux --calc-scores "ridge/scores_test" \
                --scorefile "ridge/ridge.effects" \
                --bfile simulation/sample/data \
                --power 0 \
                --pheno simulation/pheno/pheno.pheno \
                --remove simulation/subsets/training.fam
## Calculate a tagging file and heritability matrix
./ldak5.2.linux --calc-tagging simulation/taggings/her \
                --bfile simulation/sample/data \
                --ignore-weights YES \
                --power 0 \
                --window-kb 1000  \
                --save-matrix YES \
                --remove simulation/subsets/test.fam 

#. Simulate per-predictor heritabilitiess
./ldak5.2.linux --sum-hers simulation/taggings/sumhers \
                --tagfile simulation/taggings/her.tagging \
                --summary simulation/linreg/linreg.summaries \
                --matrix simulation/taggings/her.matrix \
                --remove simulation/subsets/test.fam 
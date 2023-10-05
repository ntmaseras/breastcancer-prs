## 1. Calculate weightings
./ldak5.2.linux --cut-weights bld_ldak/sections --bfile simulation/sample/data

./ldak5.2.linux --calc-weights-all bld_ldak/sections --bfile simulation/sample/data 
mv bld_ldak/sections/weights.short bld65

## 2. Calculating tagging files
../../ldak5.2.linux --calc-tagging bld.ldak \
           --bfile ../../simulation/sample/data \
           --ignore-weights YES \
           --power -.25 \
           --annotation-number 65 \
           --annotation-prefix bld \
           --window-kb 1000 \
           --save-matrix YES


./ldak.out --sum-hers bld.ldak --tagfile bld.ldak.tagging --summary quant.summaries --matrix bld.ldak.matrix


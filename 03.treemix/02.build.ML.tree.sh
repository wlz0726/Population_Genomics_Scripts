mkdir 02.build.ML.tree.sh.out
for i in 1 100 200 500 1000
do 
  echo "/home/wanglizhong/software/treemix/treemix-1.12/src/treemix -i treemix.input.gz -k $i -o 02.build.ML.tree.sh.out/02.ML.tree.k$i -root AF-YRI,AF-LWK,AF-GWD,AF-MSL,AF-ESN,AF-ASW,AF-ACB ; /ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript plot.R 02.build.ML.tree.sh.out/02.ML.tree.k$i "
done


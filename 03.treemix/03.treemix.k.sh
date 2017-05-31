mkdir 03.treemix.k.sh.out
for i in {1..10}
do
  echo "/home/wanglizhong/software/treemix/treemix-1.12/src/treemix -i treemix.input.gz -k 500 -m $i -root AF-YRI,AF-LWK,AF-GWD,AF-MSL,AF-ESN,AF-ASW,AF-ACB -o 03.treemix.k.sh.out/03.treemix.k500.$i ; /ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript plot.R 03.treemix.k.sh.out/03.treemix.k500.$i; perl treemix_fraction.pl 03.treemix.k.sh.out/03.treemix.k500.$i > 03.treemix.k.sh.out/03.treemix.k500.$i.fraction; "
  #echo "/home/wanglizhong/software/treemix/treemix-1.12/src/treemix -i treemix.input.gz -k 1000 -m $i -root AF-YRI,AF-LWK,AF-GWD,AF-MSL,AF-ESN,AF-ASW,AF-ACB -o 03.treemix.k.sh.out/03.treemix.k1000.$i ; /ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript plot.R 03.treemix.k.sh.out/03.treemix.k1000.$i"
done


for i in ../01.CNV.calling/02.CNVnatorFilter.pl.1000.out/*cnv
  do
  ln -s $i .
done


for j in ./*cnv
  do
  perl hist.pl $j V3
done
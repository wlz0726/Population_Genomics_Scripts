mkdir 04.f3f4.out
for i in 500
do
  echo "/home/wanglizhong/software/treemix/treemix-1.12/src/threepop -i treemix.input.gz -k $i > 04.f3f4.out/04.1.f3.win$i;  cat 04.f3f4.out/04.1.f3.win$i|grep -v Estimating |grep -v nsnp|tr ';' ' '|awk '$5<-3' > 04.f3f4.out/04.1.f3.win$i.negtive; awk '{print $1}' 04.f3f4.out/04.1.f3.win$i.negtive |sort -u > 04.f3f4.out/04.1.f3.win$i.negtive.pop"
  echo "/home/wanglizhong/software/treemix/treemix-1.12/src/fourpop -i treemix.input.gz  -k $i > 04.f3f4.out/04.2.f4.win$i;  cat 04.f3f4.out/04.2.f4.win$i |grep -v Estimatin|grep -v nsnp |tr ',' ' '|tr ';' ' ' > 04.f3f4.out/04.2.f4.win$i.txt;"
done

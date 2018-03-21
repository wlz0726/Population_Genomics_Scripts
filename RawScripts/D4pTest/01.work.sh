rm run.sh
for i in 1
do
  #echo "perl cal_D4pTest.pl ../00.tped/01.vcf2tped.pl.out/raw.$i.tped $i.result " >>run.sh
  echo "perl cal_D4pTest_bootstrap.pl ../00.tped/01.vcf2tped.pl.out/raw.$i.tped $i.bootstrap.result " >>run.sh
done

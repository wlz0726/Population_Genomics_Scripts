rm Ztest.R
for i in 1 2 3 4 5
do
    echo $i
    
    perl sd.pl $i.bootstrap.result G1 > aa.G1.$i;less aa.G1.$i|cut -f 2|head -1|perl -e 'while(<>){chomp;my($ave,$sd)=(split)[0,1];print "pnorm(abs($ave-50),mean=0,sd=$sd,lower.tail=F)\n";}' >> Ztest.R    
    perl sd.pl $i.bootstrap.result G2 > aa.G2.$i;less aa.G2.$i|cut -f 2|head -1|perl -e 'while(<>){chomp;my($ave,$sd)=(split)[0,1];print "pnorm(abs($ave-50),mean=0,sd=$sd,lower.tail=F)\n";}' >> Ztest.R
done

Rscript Ztest.R > Ztest.R.txt
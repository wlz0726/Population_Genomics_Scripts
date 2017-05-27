my $in='input.EA';# 
# prefix of tped
die "$0 prefix.of.ped12 file \n"unless $in;

my $out1="$0.admixture";
`mkdir $out1`unless -e $out1;

my $pwd=`pwd`; chomp $pwd;
`mkdir pdf`unless -e pdf;


open(O1,"> $0.1.admixture.sh");
open(O2,"> $0.2.plot.sh");
for(my $j=1;$j<=10;$j++){ # 10 times of admixture with different seed
    my $seed=int rand(1000000);
    my $outdir2="$out1/admix.repeat$j";
    `mkdir -p $outdir2`unless -e $outdir2;
    # k from 1 to 10
    for(my $k=1;$k<=10;$k++){
	print O1 "cd $outdir2; ln -s ../../$in.ped $in.ped; ln -s ../../$in.map $in.map; /ifshk7/BC_RES/TECH/PMO/F13FTSNWKF2248_HUMmuzR/songli/ZangYi_Project/1kg/bin/admixture_linux-1.3.0/admixture --cv -s $seed -j30 $in.ped $k > $in.log$k.out; rm $in.$k.P ;cd $pwd; \n"
	}
    # step2: plot admix 2-10
    print O2 "perl cv.error.pl $outdir2; perl poplist.EA.pl $outdir2; perl plot.admixture.EA.pl $outdir2 4;cp $outdir2/01.cv.error.pdf pdf/SNPset.$in.AdmixRepeat$j.cv.error.pdf; cp $outdir2/03.plot.admixture.pdf pdf/SNPset.$in.AdmixRepeat$j.admixture2-10.pdf; cp $outdir2/01.cv.error pdf/SNPset.$in.AdmixRepeat$j.cv.error.txt\n";
    
}
close O1;
close O2;



    

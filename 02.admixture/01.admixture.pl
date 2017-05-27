# wanglizhong
# admixture

# input file : input.ped, 12-code ped file
my $in=input; # prefix of ped
die "$0 prefix.of.ped12 file \n"unless $in;
my $max_k=10;
my $repeat_time=10;
my $plot_num=9; # 2-10, 9 plots


my $out1="$0.admixture";
`mkdir $out1`unless -e $out1;

my $pwd=`pwd`; chomp $pwd;
`mkdir pdf`unless -e pdf;

open(O1,"> $0.1.admixture.sh");
open(O2,"> $0.2.plot.sh");
for(my $j=1;$j<=$repeat_time;$j++){ # 10 times of admixture with different seed
    my $seed=int rand(1000000);
    my $outdir2="$out1/admix.repeat$j";
    `mkdir -p $outdir2`unless -e $outdir2;
    # k from 1 to 10
    for(my $k=1;$k<=$max_k;$k++){
	print O1 "cd $outdir2; ln -s ../../$in.ped input.ped; ln -s ../../$in.map input.map; /ifshk7/BC_RES/TECH/PMO/F13FTSNWKF2248_HUMmuzR/songli/ZangYi_Project/1kg/bin/admixture_linux-1.3.0/admixture --cv -s $seed -j30 input.ped $k > input.log$k.out ;cd $pwd; \n"
	}
    
# step2: plot admix 2-10
    print O2 "perl cv.error.pl $outdir2; perl poplist.pl $outdir2; perl plot.admixture.pl $outdir2 $plot_num;cp $outdir2/01.cv.error.pdf pdf/$in.AdmixRepeat$j.cv.error.pdf; cp $outdir2/03.plot.admixture.pdf pdf/$in.AdmixRepeat$j.admixture.pdf;";
# plot k=7 and k=8    
#print O2 "perl plot.admixture.v2.pl $outdir2;cp $outdir2/03.plot.admixture.v2.pdf pdf/$in.AdmixRepeat$j.admixture.v2.pdf; cp $outdir2/01.cv.error pdf/$in.AdmixRepeat$j.cv.error.txt\n";
}
close O1;
close O2;



    

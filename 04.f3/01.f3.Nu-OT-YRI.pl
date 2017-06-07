# need input file: input.EIGENSTRAT.geno, input.EIGENSTRAT.ind, input.EIGENSTRAT.snp

# Outgroup f3(NU, OT; YRI)
# Nu-OT-YRI
# Other Tibetan-Yi pops (OT)

# ============ define the pops
my @pop1=("ZY-NU","ZY-DRU","ZY-MBA","ZY-LBA");# unadmix pop: NU
my @pop2=("ZY-ACH","ZY-BAI","ZY-DRU","ZY-HAN","ZY-HNI","ZY-HUI","ZY-JNO","ZY-JPO","ZY-LBA","ZY-LHU","ZY-LSU","ZY-MBA","ZY-MON","ZY-NAX","ZY-NU","ZY-PMI","ZY-QIA","ZY-TIB","ZY-UN","ZY-UYG","ZY-YI"); # all zangyi pop
my @pop3=("AF-YRI"); # outgroup
# ============

open(O1,"> $0.list");
for(my $m=0;$m<@pop1;$m++){
    my $m2=$pop1[$m];
    for( my $n=0;$n<@pop2;$n++){
	my $n2=$pop2[$n];
	next if($m2 eq $n2);
	for(my $j=0;$j<@pop3;$j++){
	    my $j2=$pop3[$j];
	    next if($m2 eq $j2 || $n2 eq $j2);
	    print O1 "$m2\t$n2\t$j2\n";
	}
    }
}
close O1;

open(O2,"> $0.par");
print O2 "SSS:  input.EIGENSTRAT
indivname:    SSS.ind
snpname:      SSS.snp
genotypename: SSS.geno
popfilename:  $0.list
";
close O2;

open(O3,"> $0.sh");
print O3 "/home/wanglizhong/software/admixtools/AdmixTools/bin/qp3Pop $0.par > $0.par.log; \n";
close O3;

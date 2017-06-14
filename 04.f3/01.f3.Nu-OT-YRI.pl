# need input file: input.EIGENSTRAT.geno, input.EIGENSTRAT.ind, input.EIGENSTRAT.snp

# Outgroup f3(NU, OT; YRI)
# Nu-OT-YRI
# Other Tibetan-Yi pops (OT)

# ============ define the pops
my @pop1=("TY-NU","TY-DRU","TY-MBA","TY-LBA","TY-TIB-W04","TY-TIB-W07","EA-CDX");# unadmix pop: NU
my @pop2=("TY-ACH","TY-BAI","TY-DRU","TY-HAN","TY-HNI","TY-HUI","TY-JNO","TY-JPO","TY-LBA","TY-LHU","TY-LSU","TY-MBA","TY-MON","TY-NAX","TY-NU","TY-PMI","TY-QIA","TY-UYG","TY-YI","TY-TIB-W01","TY-TIB-M04","TY-TIB-W02","TY-TIB-W04","TY-TIB-W07","TY-TIB-W09","EA-CDX","EA-CHB","EA-CHS","EA-JPT"); # all zangyi pop + CDX, CHB, CHS
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
print O3 "/home/wanglizhong/software/admixtools/AdmixTools/bin/qp3Pop -p $0.par > $0.par.log; \n";
close O3;

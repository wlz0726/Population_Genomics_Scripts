my @per=(0.05,0.1,0.2,0.3,0.4,0.5);

open(O1,"> $0.1.sh");
open(O2,"> $0.2.sh");
foreach my $per(@per){
    print O1 "mkdir $per; ";
    print O1 "ln -s ../../06.admixtools.rm.singltons/01.Rolloff.V3.22.pl.out/$per/input.EIGENSTRAT.geno $per/input.EIGENSTRAT.geno; ";
    print O1 "ln -s ../../06.admixtools.rm.singltons/01.Rolloff.V3.22.pl.out/$per/input.EIGENSTRAT.ind $per/input.EIGENSTRAT.ind;";
    print O1 "ln -s ../../06.admixtools.rm.singltons/01.Rolloff.V3.22.pl.out/$per/input.EIGENSTRAT.snp $per/input.EIGENSTRAT.snp;";
    print O1 "cp run.par $per;\n";
    
    print O2 "cd $per; /ifshk5/PC_HUMAN_EU/USER/wanglizhong/software/alder/alder/alder -p run.par > run.par.log;\n";
}
close O1;
close O2;

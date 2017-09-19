#!/usr/bin/perl -w
use strict;
# need input file: input.EIGENSTRAT.geno, input.EIGENSTRAT.ind, input.EIGENSTRAT.snp

# ============ define the pops
my @pop1=("OCAN","ODAL","MPS","IROV","IROO");
my @pop2=("AWD","EMZ","NQA","RDA","MODA","BCS","GCN","BMN","BSI","AME","GME","DOP","TEX","BGE","GUR","GAR","SUM","AFS","AW","CC","IROA","KRS","KR","NDZ","SKZ","AWT","ALT","BAS","BAY","DUL","HET","KAZ","QIB","TUB","GLT","HUL","HUS","JZS","LLT","LOP","LTH","LZM","SNT","SSF","STH","TAN","THF","TON","UJI","WDS","YFT","CHA","DQS","GBF","HZS","MBF","OLA","TCS","TIB","TIBQ","TIBS","WNS","LPB","NLB","SPG","ZTS");
## pop3 outgroup or target pop
my @pop3=("AWD","EMZ","NQA","RDA","MODA","BCS","GCN","BMN","BSI","AME","GME","DOP","TEX","BGE","GUR","GAR","SUM","AFS","AW","CC","IROA","KRS","KR","NDZ","SKZ","AWT","ALT","BAS","BAY","DUL","HET","KAZ","QIB","TUB","GLT","HUL","HUS","JZS","LLT","LOP","LTH","LZM","SNT","SSF","STH","TAN","THF","TON","UJI","WDS","YFT","CHA","DQS","GBF","HZS","MBF","OLA","TCS","TIB","TIBQ","TIBS","WNS","LPB","NLB","SPG","ZTS");
# split into 200 parallel
my $split_num=200;
# ============

my $out="$0.out";
`mkdir $out`unless -e $out;

open(O1,"> $out/$0.list");
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

`perl /ifshk7/BC_PS/wanglizhong/bin/000.split.sh.pl $out/$0.list $split_num`;

open(O3,"> $0.sh");
my @list=<$out/$0.list.s.*>;

foreach my $list(@list){
open(O2,"> $list.par");
print O2 "SSS:  input.EIGENSTRAT
indivname:    SSS.ind
snpname:      SSS.snp
genotypename: SSS.geno
popfilename:  $list
";
close O2;

print O3 "/home/wanglizhong/software/admixtools/AdmixTools/bin/qp3Pop -p $list.par > $list.par.log; \n";
}
close O3;

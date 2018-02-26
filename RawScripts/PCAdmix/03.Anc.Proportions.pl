my $out="$0.out";
`mkdir $out`unless -e $out;

my @chr=1 .. 22;
my $indlist="Ind.ChinaTau.list";
open(I,"$indlist");
open(O,"> $0.sh");
while(<I>){
    chomp;
    my $ind=$_;
    foreach my $chr(@chr){
	my $hap1="02.PCAdmix.pl.out/$chr/chr$chr\_$ind\_A.bed.txt";
	my $hap2="02.PCAdmix.pl.out/$chr/chr$chr\_$ind\_B.bed.txt";
	my $outfile="$out/$ind\_$chr\_bed.txt";
	print O "perl Anc.Proportions.pl $hap1 $hap2 $outfile;\n";
    }
}
close I;
close O;

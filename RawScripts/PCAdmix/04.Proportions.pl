my $out="$0.out";
`mkdir $out`unless -e $out;

my @chr=1 .. 22;
my $indlist="Ind.ChinaTau.list";
open(I,"$indlist");
open(O,"> $0.sh");
while(<I>){
    chomp;
    my $ind=$_;
    print O "perl Proportions.pl $out/$ind.txt";
    foreach my $chr(@chr){
	my $bed="03.Anc.Proportions.pl.out/$ind\_$chr\_bed.txt";
	print O " $bed";
    }
    print O "\n";
}
close I;
close O;

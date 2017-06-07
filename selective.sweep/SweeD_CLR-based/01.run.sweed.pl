my $vcf=shift;
my $grid=1000;
die "$0 vcf grid\n" unless $grid;

$vcf =~ /\/([^\/]+).vcf$/;
my $chr=$1;
#print "$chr\n";
open(O,"> $0.$chr.g$grid.sh");
print O "SweeD -name $chr.g$grid -input $vcf -grid $grid -folded\n";
close O;
`sh $0.$chr.g$grid.sh`;
`rm $0.$chr.g$grid.sh`;
open(IN,"SweeD_Report.$chr.g$grid");
open(OUT,"> SweeD_Report.$chr.g$grid.ch");
<IN>;
<IN>;
<IN>;
while(<IN>){
    print OUT "$chr\t$_";
}
close OUT;
close IN;

`mv SweeD_Report.$chr.g$grid.ch $0.out`;
`rm SweeD_Info.$chr.g$grid`;
`rm SweeD_Report.$chr.g$grid`;
#`perl plot.clr.point.pl SweeD_Report.$vcf.g$grid.ch`;

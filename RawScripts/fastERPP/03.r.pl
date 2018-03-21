my $out="$0.out";
`mkdir $out`unless -e $out;

my %ne;
open(I,"../../03.pi/03.Ne.pl.out");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $ne{$a[0]}=$a[1];
}
close I;


my @rho=<P*/*04.transFormat.pl.txt>;
foreach my $rho(@rho){
    $rho =~ /Pop\_([\w\_]+)\/04.transFormat.pl.txt/;
    my $pop=$1;
    my $ne=$ne{$pop};
    #print "$pop\t$ne\n";
    open(I,"$rho");
    open(O,"> $out/$pop");
    <I>;
    while(<I>){
	chomp;
	my ($chr,$start,$end,$mid,$Rho)=(split(/\s+/))[0,1,2,3,4];
	my $r=100*$Rho/(4*$ne); # cM/Mb
	print O "$chr\t$start\t$end\t$mid\t$Rho\t$r\n";
    }
    close I;
    close O;
}

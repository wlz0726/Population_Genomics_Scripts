my @cv=<01.admixture.pl.admixture/admix.repeat*/01.cv.error>;

my %h;
open(O,"> $0.txt");
foreach my $f(@cv){
    $f =~ /repeat(\d+)\//;
    my $repeatnum=$1;
    open(I,"$f");
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	my $k=$a[0];
	my $value=$a[1];
	print O "repeat$repeatnum\t$k\t$value\n";
    }
    close I;
	
}
close O;

`cat $0.txt|sort -k3 -g > $0.txt.sort`;

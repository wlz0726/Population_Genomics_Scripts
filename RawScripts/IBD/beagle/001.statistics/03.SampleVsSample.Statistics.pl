my $in=shift;
die "$0 02.SampleVsSample.pl.3.out\n"unless $in;
my %h;
open(I,"$in");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[0]}{$a[1]}{count}++;
    $h{$a[0]}{$a[1]}{length}+=$a[2];
}
close I;

open(O,"> $in.log");
foreach my $k1(sort keys %h){
    foreach my $k2(sort keys %{$h{$k1}}){
	my $count=$h{$k1}{$k2}{count};
	my $length=$h{$k1}{$k2}{length};
	
	print O "$k1\t$k2\t$count\t$length\n";
    }
}
close O;

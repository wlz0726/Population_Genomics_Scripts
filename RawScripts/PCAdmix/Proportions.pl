my @in=@ARGV;

my $outfile=shift @in;
open(O,"> $outfile");
my %h;
my $total=0;
my $win_number=0;
foreach my $in(@in){
    open(I,"$in");
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	my $length=$a[3];
	my $anc=$a[6];
	$h{$anc}{win}++;
	$win_number++;
	$h{$anc}{length}+=$length;
	$total+=$length;
    }
    close I;
}

$outfile =~ /\/(.*).txt/;
my $id=$1;

foreach my $k1(sort keys %h){
    my $ratio=$h{$k1}{length}/$total;
    print O "$id\t$k1\t$ratio\t$h{$k1}{win}\t$h{$k1}{length}\t$win_number\t$total\n";
}
close O;

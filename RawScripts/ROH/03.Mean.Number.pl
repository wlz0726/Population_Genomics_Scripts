my %h;
open(I,"02.ROH.cal.pl.ind.txt");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $pop=$a[0];
    my $ind=$a[1];
    my $length=$a[2];
    if($length >100){
	$h{$pop}{$ind}{b100}++;
    }
    if($length >1000){
	$h{$pop}{$ind}{b1k}++;
    }
    $h{$pop}{$ind}{length}+=$length;
}
close I;

open(O2,"> $0.txt");
print O2 "#pop\t>100k\t>1000k\n";
open(O3,"> $0.ind");
#foreach my $k1(sort keys %h){
my @pop=("BRM","GIR","NEL","LQC","NYC","LXC","YNC","QCC","YBC","JBC","RAN","FLV","HOL","LIM","JER");
foreach my $k1(@pop){

    my $all_100;
    my $all_1k;
    my $indnum=keys %{$h{$k1}};
    foreach my $k2(sort keys %{$h{$k1}}){
        my $count100=$h{$k1}{$k2}{b100};
	$all_100 +=$count100;
        my $count1k=$h{$k1}{$k2}{b1k};
	$all_1k += $count1k;
	my $length=$h{$k1}{$k2}{length};
	print O3 "$k1\t$k2\t$length\n";
    }
    my $mean_100=$all_100/$indnum;
    my $mean_1k=$all_1k/$indnum;
    print O2 "$k1\t$mean_100\t$mean_1k\n";
}
close O2;

close O3;

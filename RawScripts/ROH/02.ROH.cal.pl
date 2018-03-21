my $dir="01.ROH.pl.out";

my %pop;
open(I,"Ind.list");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    
    $pop{$a[0]}=$a[1];
}
close I;



my %h;
open(O,"> $0.ind.txt");
my @f=<$dir/*hom>;
foreach my $f(@f){
    open(I,"$f");
    <I>;
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	my $ind=$a[1];
	my $length=$a[9];
	my $pop=$pop{$ind};
	#print "$ind\t$pop\t$length\n";die;
	$h{$pop}{$ind}{all_length}+=$length;
	$h{$pop}{$ind}{count}++;
	print O "$pop\t$ind\t$length\n";
    }
    close I;
}
close O;

open(O2,"> $0.pop.txt");
print O2 "#pop\tind\ttotal_length\tnumber\n";
open(O3,"> $0.pop_ave.txt");
print O3 "#pot\tmean_total_length(kb)\tmean_roh_number\n";
#foreach my $k1(sort keys %h){
my @pop=("BRM","GIR","NEL","LQC","NYC","LXC","YNC","QCC","YBC","JBC","RAN","FLV","HOL","LIM","JER");
foreach my $k1(@pop){
    my $length_total=0;
    my $count_total=0;
    my $num=keys %{$h{$k1}};
    foreach my $k2(sort keys %{$h{$k1}}){
	
	my $length=$h{$k1}{$k2}{all_length};
	my $count=$h{$k1}{$k2}{count};
	print O2 "$k1\t$k2\t$length\t$count\n";
	
	$length_total += $length;
	$count_total += $count;
    }
    my $mean_total_length= $length_total/$num;
    my $mean_ROH_number= $count_total/$num;
    print O3 "$k1\t$mean_total_length\t$mean_ROH_number\n";
}
close O2;

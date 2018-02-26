
my $f=shift;
die "$0 03.RFMix.V2.pl.out/M54/M54 \n"unless $f;

my @f=<$f.*.rfmix.0.Viterbi.txt>;
my %h;
my $total=0;

foreach my $in(@f){
    open(I,"$in");
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	$total++;
	for(my $i=0;$i+1<@a;$i+=2){
	    my $id=$i;
	    my $hap1=$i;
	    my $hap2=$i+1;
	    
	    $h{$id}{1}+=0;
	    $h{$id}{2}+=0;
	    $h{$id}{3}+=0;
	    
	    $h{$id}{$a[$hap1]}++;
	    $h{$id}{$a[$hap2]}++;
	}
    }
    close I;
}

print "#id anc1 anc2 anc3\n";
foreach my $k1(sort{$a<=>$b} keys %h){
    print "$k1";
    foreach my $k2(sort{$a<=>$b} keys %{$h{$k1}}){
	my $count=$h{$k1}{$k2};
	my $percent=$count/($total*2);
	print " $percent";
    }
    print "\n";
}

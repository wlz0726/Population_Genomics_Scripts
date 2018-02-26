my $f=shift;
die "$0 02.seperate.pop.pl.out/Hani_M16/22.rfmix.0.Viterbi.txt\n"unless $f;

my %h;
my $total=0;
open(I,"$f");
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
	$h{$id}{4}+=0;
	$h{$id}{5}+=0;
	$h{$id}{6}+=0;
	$h{$id}{7}+=0;
	$h{$id}{8}+=0;
	
	$h{$id}{$a[$hap1]}++;
	$h{$id}{$a[$hap2]}++;
    }
}
close I;

#print "#id anc1 anc2 anc3\n";
open(O,"> $f.per");
foreach my $k1(sort{$a<=>$b} keys %h){
    #print O "$k1";
    foreach my $k2(sort{$a<=>$b} keys %{$h{$k1}}){
	my $count=$h{$k1}{$k2};
	my $percent=$count/($total*2);
	print O " $percent";
    }
    print O "\n";
}
close O;

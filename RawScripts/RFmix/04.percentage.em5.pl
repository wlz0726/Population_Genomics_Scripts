my %h;
my %h2;
my $all=0;
my @f=<03.RFMix.V3.em5.pl.out/ChinaTau/ChinaTau.*.rfmix.5.Viterbi.txt.withPos.gz>;
foreach my $f(@f){
    open(I,"zcat $f|");
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	my $length=$a[1]-$a[0];
	for(my $i=2;$i+1<@a;$i+=2){
	    my $ind=$i/2;
	    my $hap1=$a[$i];
	    my $j=$i+1;
	    my $hap2=$a[$j];
	    my $pattern=join("-",sort ($hap1,$hap2));
	    #print "$pattern\n";
	    $h{$ind}{'1-1'}{length}+=0;
	    $h{$ind}{'1-2'}{length}+=0;
            $h{$ind}{'2-2'}{length}+=0;
	    
	    $h{$ind}{$pattern}{length}+=$length;
	    $h2{$ind}{all} += $length;
	}
    }
    close I;
}

open(O,"> $0.out");
open(LOG,"> $0.log");
my @head=sort keys %{$h{1}};
print O "#Sample\t",join("\t",@head),"\n";
print LOG "TotalWinLength: $h2{1}{all}\n";
foreach my $k1(sort{$a<=>$b} keys %h){
    print O "$k1";
    foreach my $k2(sort keys %{$h{$k1}}){
	my $percent=$h{$k1}{$k2}{length}/$h2{$k1}{all};
	#print O "$k1\t$k2\t$percent\t$h{$k1}{$k2}{length}\/$ah2{$k1}{all}\n";
	print O "\t$percent";
    }
    print O "\n";
}
close O;
close LOG;

my $out="$0.out";
`mkdir $out`unless -e $out;

my @f=<03.r.pl.out/*>;
foreach my $f (@f){
    $f =~ /\/(.*)/;
    my $pop=$1;
    my %h;
    open(I,"$f");
    while(<I>){
	chomp;
	my ($chr,$start,$rho,$r)=(split(/\s+/))[0,1,4,5];
	my $new_start=(int($start/1000000))*1000000+1;
	$h{$chr}{$new_start}{rho}+=$rho;
	$h{$chr}{$new_start}{r}+=$r;
	$h{$chr}{$new_start}{count}++;
    }
    close I;
    open(O,"> $out/$pop");
    foreach my $k1(sort keys %h){
	foreach my $k2(sort keys %{$h{$k1}}){
	    my $ave_rho=$h{$k1}{$k2}{rho}/$h{$k1}{$k2}{count};
	    my $ave_r=$h{$k1}{$k2}{r}/$h{$k1}{$k2}{count};
	    print O "$pop\t$k1\t$k2\t$ave_rho\t$ave_r\n";
	}
    }
    close O;
}

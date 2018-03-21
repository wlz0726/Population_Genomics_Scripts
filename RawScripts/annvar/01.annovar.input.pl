my %h;
open(I,"zcat all.recalibrated_variants.99.9.vcf.gz|");
while(<I>){
    chomp;
    next if(/^\#/);
    my @a=split(/\s+/);
    next if(length($a[3])>1);
    next if(length($a[4])>1);
    $h{$a[0]}{$a[1]}="$a[3]\t$a[4]";
    #print "$a[0]\t$a[1]\t$a[3]\t$a[4]\n";
}
close I;

my $out="$0.out";
`mkdir $out`unless -e $out;

foreach my $k1(sort keys %h){
    open(O,"> $out/$k1.avinput");
    foreach my $k2(sort{$a<=>$b} keys %{$h{$k1}}){
	print O "$k1\t$k2\t$k2\t$h{$k1}{$k2}\n";
    }
    close O;
}

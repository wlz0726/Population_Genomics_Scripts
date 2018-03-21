my %h;
my $num=0;
my @exon=<01.thinVcf.pl.out/*exon.fa>;
foreach my $exon(sort @exon){
    open(I,$exon);
    my $in=<I>;
    $in =~ /\s+(\d+)$/;
    $num += $1;
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	$h{$a[0]} .=$a[1];
    }
    close I;
}
open(O,"> $0.exon.fa");
print O "4  $num\n";
foreach my $k(sort keys %h){
    print O "$k  $h{$k}\n";
}
close O;

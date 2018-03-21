my $in=shift;
my $outprefix=shift;

open(I,"zcat $in|");
open(O1," > $outprefix.exon.pos");
open(O2," > $outprefix.syn.pos");
<I>;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $chr=$a[0];
    $chr =~ s/Chr//;
    next if($chr eq X);
    
    my $info=$a[5];
    my $syn=$a[8];
    if($info eq exonic){
	print O1 "$chr\t$a[1]\n";
	if($syn eq synonymous){
	    print O2 "$chr\t$a[1]\n";
	}
    }
}
close I;
close O1;
close O2;

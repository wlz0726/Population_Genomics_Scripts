my $f=shift;

die "$0 01.9.ourlier.lnRpi.pl.40000.pi.per5 / 02.7.mean.top.Fst.pl.02.6.1.merge.winFst.OnlySNP.pl.02.2.generate.fst.pl.D59.W13.w50000.s10000.winFst.OnlySNP.40000.per5\n"unless $f;
my %h;
my $prechr="NA";
my $num="1";
open(IN,"$f");
while(<IN>){
    chomp;
    next if(/chr/);
    my @a=split(/\s+/);
    my $chr=$a[0];
    my $pos=$a[1];
    if($chr eq $prechr){
        my $dis=$pos-$h{$num}{$chr}{end};
        if($dis<=100000){
            $h{$num}{$chr}{end}=$pos;
        }else{
            $num++;
            $h{$num}{$chr}{start}=$pos;
            $h{$num}{$chr}{end}=$pos;
        }
    }else{
        $num++;
        $h{$num}{$chr}{start}=$pos;
        $h{$num}{$chr}{end}=$pos;
        $prechr=$chr;
    }
    
        
}
close IN;

open(OUT,"> $f.02merge");
foreach my $k1(sort{$a<=>$b} keys %h){
    foreach my $k2(sort keys %{$h{$k1}}){
        my $start=$h{$k1}{$k2}{start};
        my $end=$h{$k1}{$k2}{end}+50000;
        print OUT "$k2\t$start\t$end\n";
    }

}
close OUT;


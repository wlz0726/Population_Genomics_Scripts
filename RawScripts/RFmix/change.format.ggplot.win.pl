my $f=shift;

die "$0 03.RFMix.V5.multiple.pl.out/M54/M54.1.rfmix.0.Viterbi.txt \n"unless $f;

open(I,"$f");
open(O,"|gzip -c > $f.ggdata2.gz");
my $line=1;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $x=$line;
    for(my $i=0;$i<@a;$i++){
	my $y=$i+1;
	my $value=$a[$i];
	print O "$x\t$y\t$value\n";
    }
    $line++;
}
close I;
close O;

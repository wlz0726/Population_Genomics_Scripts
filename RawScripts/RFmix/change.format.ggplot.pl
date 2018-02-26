my $f=shift;

die "$0 03.RFMix.V5.multiple.pl.out/M54/M54.1.rfmix.0.Viterbi.txt \n"unless $f;

$f =~ /\/.*\.(\d+)\.rfmix.0.Viterbi.txt/;
my $chr=$1;
#print "$chr\n";
my $markers="02.seperate.pop.pl.out/ChinaTau/$chr.markers";
my $num=1;
my %pos;
open(I,"$markers");
#print "$markers\n";
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $pos{$num}=$a[1];
    
    $num++;
}
close I;



open(I,"$f");
open(O,"|gzip -c > $f.ggdata.gz");
my $line=1;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $x=$pos{$line};
    for(my $i=0;$i<@a;$i++){
	my $y=$i+1;
	my $value=$a[$i];
	print O "$x\t$y\t$value\n";
    }
    $line++;
}
close I;
close O;

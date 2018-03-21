my $ibd="01.Beagle.ibd.pl.out.all.ibd";
my $min_lod=shift;
die "$0 <min_lod>\n"unless $min_lod;

my %species;
open(I,"../../PopOrder.txt");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $id;
    $species{$a[3]}="$a[0].$a[1]";
}
close I;

my %h;
open(I,"$ibd");
open(O,"> $0.$min_lod.out");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $id1=$a[0];
    my $id2=$a[2];
    $id1 =~ /^(\w\w\w)\d+$/;
    my $pop1=$1;
    my $sp1=$species{$pop1};
    $id2 =~ /^(\w\w\w)\d+$/;
    my $pop2=$1;
    my $sp2=$species{$pop2};
    my $sample1="$sp1.$id1";
    my $sample2="$sp2.$id2";
    
    my $pos1=$a[5]; 
    my $pos2=$a[6];
    my $length=$pos2-$pos1+1;
    my $lod=$a[7];
    if($lod < $min_lod){
	$length=0;
	next;
    }
    my @sample=($sample1,$sample2);
    my @sortsample=sort(@sample);
    print O join("\t",@sortsample),"\t$length\n";
}
close I;
close O;

`perl 03.SampleVsSample.Statistics.pl $0.$min_lod.out`;
`perl 04.IndVsInd.pl $0.$min_lod.out.log`;
`perl 04.PopVsPop.pl $0.$min_lod.out.log`;
`perl 05.plot.matrix.pl $0.$min_lod.out.log.Ind.matrix`;
`perl 05.plot.matrix.pl $0.$min_lod.out.log.Pop.matrix`;

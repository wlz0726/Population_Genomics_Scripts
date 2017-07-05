# Please make sure that for the bin size you are using the ratio of average to its sd is around 4-5.


my @f=<01.test.bin.pl.out/*/*l3>;
my %h;
foreach my $f (sort @f){
    $f =~ /\/([^\/]+)\.scaffold10\.(\d+).root/;
    my $sample=$1;
    my $bin=$2;
    open(I,"$f");
    <I>;
    my $in1=<I>;
    $in1=~/Average RD per bin \(1-22\) is ([\d\.]+) \+\- ([\d\.]+) \(before GC correction\)/;
    my $ave1=$1;
    my $sd1=$2;
    my $rat1=$ave1/$sd1;
    <I>;<I>;<I>;
    my $in2=<I>;
    $in2=~/Average RD per bin \(1-22\) is ([\d\.]+) \+\- ([\d\.]+) \(after/;
    my $ave2=$1;
    my $sd2=$2;
    my $rat2=$ave2/$sd2;
    close I;
    print "$sample\t$bin\t$ave1\t$sd1\t$rat1\t$ave2\t$sd2\t$rat2\n";
}

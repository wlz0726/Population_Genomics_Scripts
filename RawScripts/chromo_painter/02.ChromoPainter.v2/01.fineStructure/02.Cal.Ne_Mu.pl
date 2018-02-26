
my %h;
open(I,"01.First.Run.pl.txt");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[0]}=$a[1];
}
close I;

my %out;

my @f=<01.First.Run.pl.out/*.EMprobs.out>;
foreach my $f(@f){
    $f =~ /\/(.*).EMprobs.out/;
    my $chr=$1;
    my $snpnum=$h{$chr};
    open(IN,"$f");
    while(<IN>){
	chomp;
	my $id=$_;
	<IN>;
	<IN>;<IN>;<IN>;<IN>;<IN>;
	<IN>;<IN>;<IN>;<IN>;<IN>; # 10
	<IN>;
	
	my $in=<IN>; # 12 EM
	chomp $in;
	my @a=split(/\s+/,$in);
	my $ne=$a[3];
	my $mu=$a[4];
	
	$out{$id}{$chr}{snpnum}=$snpnum;
	$out{$id}{$chr}{ne}=$ne;
	$out{$id}{$chr}{mu}=$mu;
	#<IN>;<IN>;<IN>;
    }
    close IN;
}

my $ne3=0;
my $mu3=0;
my $num3=0;

open(OUT,"> $0.txt");
foreach my $k1(keys %out){
    my $ne1=0;
    my $mu1=0;
    my $number=0;
    foreach my $k2(keys %{$out{$k1}}){
	my $snpnum=$out{$k1}{$k2}{snpnum};
	my $ne=$out{$k1}{$k2}{ne};
	my $mu=$out{$k1}{$k2}{mu};
	$ne1 += ($snpnum*$ne);
	$mu1 += ($snpnum*$mu);
	$number += $snpnum;
	#print "$k1\t$k2\t$ne\t$mu\t$snpnum\n";
    }
    my $ne2=$ne1/$number;
    my $mu2=$mu1/$number;
    print OUT "$k1\t$ne2\t$mu2\t$number\n";
    $ne3+=$ne2;
    $mu3+=$mu2;
    $num3++;
}
my $ne4=$ne3/$num3;
my $mu4=$mu3/$num3;

print OUT "\n#Individuals_average: $ne4\t$mu4\n";
close OUT;


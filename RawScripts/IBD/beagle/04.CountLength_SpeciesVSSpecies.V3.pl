my $ibd="01.Beagle.ibd.pl.out.all.ibd";
my $min_lod=shift;
die "$0 <ibd> <min_lod>\n"unless $min_lod;

my $out="$0.out";
`mkdir $out`;

my %species;
open(I,"../Pop.list");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $id;
    if($a[0] =~ /^Bos_indicus$/){
        $id=ind;
    }elsif($a[0] =~ /^Bos_taurus\&Bos_indicus$/){
        $id=hyb;
    }elsif($a[0] =~ /^Bos_taurus$/){
        $id=tau;
    }
    $species{$a[1]}=$id;
}
close I;

my %h;
open(I,"$ibd");
#open(O,"> $out/$0.$min_lod.out");
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

    my $sample1="$sp1";
    my $sample2="$sp2";
    
    my $pos1=$a[5];
    my $pos2=$a[6];
    my $length=$pos2-$pos1+1;
    my $int=int($length/50000)+1;
    $length=$int*50;
    my $lod=$a[7];
    next if($lod < $min_lod);
    
    if($sample1 eq $sample2){
        $h{$sample1}{$sample2}{$length}++;
    }else{
        $h{$sample1}{$sample2}{$length}++;
        $h{$sample2}{$sample1}{$length}++;
    }
    
}
close I;

foreach my $k1(sort keys %h){
    foreach my $k2(sort keys %{$h{$k1}}){
	open(O,"> $out/$k1.$k2.$min_lod.txt");
	foreach my $k3 (sort{$a<=>$b} keys %{$h{$k1}{$k2}}){
	    print O "$k3\t$h{$k1}{$k2}{$k3}\n";
	}
	close O;
    }
}
close O;

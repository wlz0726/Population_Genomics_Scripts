my $ibd=shift;
my $min_lod=shift;
die "$0 <ibd> <min_lod>\n"unless $min_lod;

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
    #my $int=int($length/500)+1;
    #$length=$int*500;
    my $lod=$a[7];
    if($lod < $min_lod){
        $length=0;
    }
    
    if($sp1 eq $sp2){
        $h{$sp1}{$sp2}+= $length;
    }else{
        $h{$sp1}{$sp2}+= $length;
        $h{$sp2}{$sp1}+= $length;
    }
    
}
close I;

foreach my $k1(sort keys %h){
    foreach my $k2(sort keys %{$h{$k1}}){
	print O "$k1\t$k2\t$h{$k1}{$k2}\n";
    }
}
close O;

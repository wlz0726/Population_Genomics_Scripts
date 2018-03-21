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
    #print "$sample1\t$sample2\n";die;
    my $pos1=$a[5]; 
    my $pos2=$a[6];
    my $length=$pos2-$pos1+1;
    my $lod=$a[7];
    if($lod < $min_lod){
	$length=0;
    }
    
    if($sample1 eq $sample2){
	$h{$sample1}{$sample2}+= $length;
    }else{
	$h{$sample1}{$sample2}+= $length;
	$h{$sample2}{$sample1}+= $length;
    }
}
close I;

my @id=sort keys %h;
print O " \t",join("\t",@id),"\n";
foreach my $k1(@id){
    print O "$k1";
    foreach my $k2(@id){
	my $tmp;
	
	if(exists $h{$k1}{$k2} && $h{$k1}{$k2}!=0){
	    $tmp=log($h{$k1}{$k2})/log(10);
	}elsif($k1 eq $k2){
	    $tmp=10;
	}else{
	    $tmp=0;
	}
	print O "\t$tmp";
    }
    print O "\n";
}


close O;

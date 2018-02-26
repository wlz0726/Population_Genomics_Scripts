my $hap1=shift;
my $hap2=shift;
my $out=shift;


open(I1,"$hap1");
open(I2,"$hap2");
open(O,"> $out");
<I1>;
<I2>;
while(<I1>){
    my @a=split(/\s+/);
    my $hap2_info=<I2>;
    my @b=split(/\s+/,$hap2_info);
    
    my $chr=$a[0];
    my $length=($a[2]-$a[1]+1);
    
    # hap1
    my $anc1=$a[3];
    my $posterior_probablity_threshold_1 = $a[7]; # > 0.9
    if($posterior_probablity_threshold_1 < 0.9){
	$anc1 ="NA";
    }
    # hap2
    my $anc2=$b[3];
    my $posterior_probablity_threshold_2 = $b[7];
    if($posterior_probablity_threshold_2 < 0.9){
        $anc2 ="NA";
    }
    
    my @tmp=("$anc1","$anc2");
    my @tmp2=sort @tmp;
    my $id=join("/",@tmp2);
    
    print O "$chr\t$a[1]\t$a[2]\t$length\t$anc1\t$anc2\t$id\n";
}
close I1;
close I2;
close O;

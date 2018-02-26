my %pop;
open(I,"../../../integrated_call_samples_v3.20130502.ALL.panel");
<I>;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $pop{$a[0]}=$a[1];
}
close I;

open(I,"../../../ZangYi.pop.info.txt");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $pop{$a[0]}=$a[3];
}
close I;



open(I,"zcat ../../../02.SNP/phased.combined1kg/chr1.vcf.gz|");
open(O,"> $0.txt");
open(E,"> $0.erro");
while(<I>){
    chomp;
    next if(/\#\#/);
    if(/\#/){
	my @a=split(/\s+/);
	for(my $i=9;$i<@a;$i++){
	    if(exists $pop{$a[$i]}){
		print O "$a[$i]\t$pop{$a[$i]}\n";
	    }else{
		print E "$a[$i]\n";
	    }
	}
	
	
	last;
    }
}
close I;
close O;
close E;

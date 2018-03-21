my $in=shift;
die "$0 02.SampleVsSample.pl.3.out.log \n"unless $in;

my %h;
open(I,"$in");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    #$a[0] =~ /(\w\w\w\.\w\w\w)\d+/;
    #my $pop1=$1;
    #$a[1] =~ /(\w\w\w\.\w\w\w)\d+/;
    #my $pop2=$1;
    my $pop1=$a[0];
    my $pop2=$a[1];
    if($pop1 eq $pop2){
	$h{$pop1}{$pop2}{length}+=$a[3];
	$h{$pop1}{$pop2}{count}++;
    }else{
	$h{$pop1}{$pop2}{length}+=$a[3];
        $h{$pop1}{$pop2}{count}++;
	
	$h{$pop2}{$pop1}{length}+=$a[3];
        $h{$pop2}{$pop1}{count}++;

	
    }

}
close I;

open(O,"> $in.Ind.matrix");
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

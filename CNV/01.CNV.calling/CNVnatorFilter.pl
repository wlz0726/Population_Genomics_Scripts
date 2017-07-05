my $raw_cnv=shift;
my $filter_cnv=shift;
my $pvalue=shift;
die "$0 <raw_cnv.input> <out.prefix> <e-val1>\n"unless $pvalue;

#  Filter rules removed
# 1. q0 >= 0.5 
# 2. e-val1 >= 0.01

open(I,  "$raw_cnv");
open(O1, "> $filter_cnv.del");
open(O12,"> $filter_cnv.del.bed");
open(O2, "> $filter_cnv.dup");
open(O22,"> $filter_cnv.dup.bed");
while(<I>){
    chomp;
    my ($type,$q0,$evalue,$region)=(split(/\s+/))[0,8,4,1];
    $region =~ /(\w+):(\d+)\-(\d+)/;
    my ($chr,$start,$end)=($1,$2,$3);
    
    # filter1 rule 1 and 2
    next if($q0>=0.5 || $evalue>=$pvalue);
    
    # split deletion and duplication
    if($type =~ /deletion/){
	print O1 "$_\n";
	print O12 "$chr\t$start\t$end\t$region\n";
    }elsif($type =~ /duplication/){
	print O2 "$_\n";
	print O22 "$chr\t$start\t$end\t$region\n";
    }
}
close I;
close O1;
close O12;
close O2;
close O22;

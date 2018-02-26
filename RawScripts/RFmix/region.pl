#!/usr/bin/perl
use strict;
use warnings;

my $markers=shift;
#my $exclude=shift;
my $SNPsPerWindow=shift;
my $rfmix=shift;

my $outfile="$rfmix.withPos.gz";#"M54.21.rfmix.0.Viterbi.txt.withPos.gz";
#my $ggdata="M54.21.rfmix.0.Viterbi.txt.ggdata.gz";
# 0 based positions; exclude sites
#my %rm;
#open(EXCLUDE,"$exclude");
#while(<EXCLUDE>){
#    chomp;
#    $rm{$_}++;
#}
#close EXCLUDE;

# left sites
my %h;
my $num1=0; # raw number
my $num2=0; # new number
open(POS,"$markers");
while(<POS>){
    chomp;
    my @a=split(/\s+/);
    my $position=$a[1];
    #if(exists $rm{$num1}){
    #}else{
    $h{$num2}=$position;
    #print "$num2\t$num1\t$position\n";
    $num2++;
    #}
    $num1++;
}
close POS;

my $total=0;
open(WIN,"$SNPsPerWindow");
open(RFMIX,"$rfmix");
open(OUT1,"|gzip -c > $outfile");
while(<WIN>){
    chomp;
    my $SnpNumber=$_;
    my $ancInfo=<RFMIX>;
    chomp $ancInfo;

    my $start;
    if($total==0){
        $start=0;
    }else{
	$start=$total;
    }
    my $end=$SnpNumber+$total-1;
    my $startPos=$h{$start};
    my $endPos=$h{$end};
    $total+=$SnpNumber;
    my $length=$endPos-$startPos+1;
    #print "$start\t$end\t$SnpNumber || $startPos\t$endPos| $length|$ancInfo\n";
    print OUT1 "$startPos\t$endPos\t$ancInfo\n";
}
close WIN;
close RFMIX;
close OUT1;

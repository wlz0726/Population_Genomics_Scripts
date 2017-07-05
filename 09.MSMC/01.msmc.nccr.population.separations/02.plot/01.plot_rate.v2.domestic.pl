#!/usr/bin/perl
use strict;
use warnings;

my @f=@ARGV;
die "$0 outprefix FLV_NEL.outfile.final.txt JBC_NEL.outfile.final.txt ...\n"unless @ARGV;
my @out;
my $out=shift(@f);
open(O,"> $0.$out.sh");
print O "cat ";
for my $f(@f){
    #$f =~ s/nccr.8haps.//;
    $f =~/^(.+).final.txt/;
    my $id=$1;
    $id =~ s/_/-/;
    print O " $f";
    push(@out,"$id");
}
print O "> aa;\n";
print O "perl plot_rate.v2color.pl -M \"",join(",",@out),"\" -u 7.5e-9 -g 3 -x 1000 -X 15000 -Y 1.1 -R -P \"left top\" $out aa; rm  aa *Good *epss ;\n\n";
# rm $out*txt
`sh $0.$out.sh`;
#`rm $0.$out.sh`;

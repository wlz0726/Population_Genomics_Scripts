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
    $f =~/^([-a-zA-Z\d]+)/;
    my $id=$1;
    $id =~ s/_/-/;
    print O " $f";
    push(@out,"$id");
}
print O "> aa;\n";
print O "perl plot_rate.pl -M \"",join(",",@out),"\" -u 1.25e-8 -g 30 -x 100 -X 1000000 -Y 1.1 -R -P \"right top\" $out aa; rm  aa *Good *epss out*txt;\n\n";
# rm $out*txt
`sh $0.$out.sh`;

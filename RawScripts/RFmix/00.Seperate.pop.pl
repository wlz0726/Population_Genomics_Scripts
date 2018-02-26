#!/usr/bin/perl
use strict;
use warnings;

my %h;
open(I,"00.print.ind.pop.pl.txt");
while(<I>){
    my @a=split(/\s+/);
    $h{$a[1]}{$a[0]}++;
}
close I;

my $out="$0.out";
`mkdir $out`unless -e $out;
foreach my $k1(sort keys %h){
    open(O,"> $out/$k1.txt");
    foreach my $k2(sort keys %{$h{$k1}}){
	print O "$k2\n";
    }
    close O;
}

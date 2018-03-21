#!/usr/bin/perl
use strict;
use warnings;

while(<>){
    chomp;
    if(/^\#\#/){
	print "$_\n";
	next;
    }
    if(/^\#/){
	my @a=split(/\s+/,$_);
	my $tmp = pop(@a);
	print join("\t",@a),"\n";
	next;
    }
    my @a=split(/\s+/);
    my $gt1=pop(@a);
    my $gt2=pop(@a);
    
    $gt1 =~ /(.*)\|(.*)/;
    my @gt1=("$1","$2");
    my $rand1=int(rand(2));
    my $geno1=$gt1[$rand1];
    
    $gt2 =~ /(.*)\|(.*)/;
    my @gt2=("$1","$2");
    my $rand2=int(rand(2));
    my $geno2=$gt2[$rand2];
    
    my $gt="$geno1|$geno2";
    print join("\t",@a),"\t$gt\n";
}

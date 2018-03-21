#!/usr/bin/perl
use strict;
use warnings;

my %h;
open(I,"rename.txt");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[0]}=$a[1];
}
close I;

open(I,"download.fa.align.table");
open(O,"> download.fa.align.table.rename");
my $in=<I>;chomp $in;
my @a=split(/\s+/,$in);
for(my $i=1;$i<@a;$i++){
    my $tmp=$a[$i];
    print "$tmp\n";
    if(exists $h{'$tmp'}){
	my $id=$h{$tmp};
	print "$id\t$a[$i]\n";
	$a[$i]=$id;
    }
}
print O join(" ",@a),"\n";
while(<I>){
    print O "$_";
}
close O;
close I;

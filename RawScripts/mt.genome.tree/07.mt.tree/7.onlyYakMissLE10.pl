use strict;
use warnings;

my %site;
open (F,"6.stastic.pl.coordmisfenbu")||die"$!";
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    next if /^coord/;
    next if ($a[2]>0.1 || $a[4]>0.1);
    $site{$a[0]}=0;
}
close F;

open (F,"1.diftype.pl.list")||die"$!";
open (O,">7.onlyYakMissLE10.pl.list")||die"$!";
while (<F>) {
    chomp;
    my @a=split (/\s+/,$_);
    next if ! exists $site{$a[0]};
    print O "$_\n";
    $site{$a[0]}=$a[1];
}
close F;
close O;

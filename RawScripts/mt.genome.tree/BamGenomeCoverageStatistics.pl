#! /usr/bin/perl -w
use strict;
use warnings;

print "#ID\tCoveredSites\tSumDepth\n";
my $file=shift;
my $effective_length=shift;
die "$0 bam effective_length\n"unless $file;
my $id;
if($file=~m/(\S+)\.bam$/){
    $id=$1;
}else{
    die "$file\n";
}
my $sites=0;
my $depth=0;
open(F,"/home/wanglizhong/bin/samtools depth $file |");
while(<F>){
    chomp;
    next if(/^\s*$/);
    my @a=split("\t",$_);
    $sites++;
    $depth+=$a[2];
}
close(F);

my $coverage=$sites/$effective_length;
my $depth2=$depth/$effective_length;
#print "$id\t$sites\t$depth\n";
print "$id\t$coverage\t$depth2\n";


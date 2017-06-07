#!/usr/bin/perl
use strict;
use warnings;

my $in=shift;
die "$0 01.run.sweed.pl.out.all.w50000.s50000.out\n"unless $in;

my $total;my $num;my $mean;
my %pi;
open(IN,"$in");
while(<IN>){
    chomp;
    my @a=split(/\s+/);
    my $chr=$a[1];
    my $start=$a[2];
    my $pi=$a[3];
    
    # mean
    $total += $pi;
    $num++;
     
    # top
    $pi{$pi}++;
}
close IN;

$mean=$total/$num;
open(LOG,"> $in.log");
print LOG "mean: $mean\n";

my $pi_num=keys %pi;
my $per1=int($pi_num * 0.01);
my $per3=int($pi_num * 0.03);
my $per5=int($pi_num * 0.05);

my @pi_sort=sort{$b<=>$a} keys %pi;
my $per1_limit=$pi_sort[$per1];
my $per3_limit=$pi_sort[$per3];
my $per5_limit=$pi_sort[$per5];
my $biggest=$pi_sort[0];
print LOG "
total num of pi values: $pi_num
$per1\t$per1_limit
$per3\t$per3_limit
$per5\t$per5_limit
biggest\t$biggest
";

open(IN,"$in");
open(O1,"> $in.per1");
open(O3,"> $in.per3");
open(O5,"> $in.per5");
while(<IN>){
    chomp;
    my @a=split(/\s+/);
    my $chr=$a[1];
    my $start=$a[2];
    my $pi=$a[3];
    
    my $print="$chr\t$start\t$pi\n";
    
    if($pi>=$per1_limit){
        print O1 "$print";
    }
    if($pi>=$per3_limit){
        print O3 "$print";
    }
    if($pi>=$per5_limit){
        print O5 "$print";
    }

}
close IN;
close O1;
close O3;
close O5;

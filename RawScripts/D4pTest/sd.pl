#!/usr/bin/perl
use warnings;
use strict;
#tongji
if (@ARGV !=2) {
	print "perl $0 <in><G1|G2>\n";
	exit 0;
}
my ($in,$type)=@ARGV;
if($in=~/.gz/) {open IN,"zcat $in|" or die $!;}  else{open IN,$in or die $!;}
my $order=100;
my $snp_order=0;
if($type eq "G1") {$order=2;$snp_order=0;}
elsif($type eq "G2") {$order=3;$snp_order=1;}
else{die "wrong: $type\n";}
#open OUT,'>',$out or die $!;
my %hash=();
my $sum=0;
my $num=0;
my $snp_sum=0;
while(<IN>){
    chomp;
    my @s=split(/\s+/,$_);
    my $freq=$s[$order]*100;
    $sum+=$freq;
    $snp_sum+=$s[$snp_order];
    $num++;
}
my $ave=$sum/$num;
my $snp_ave=sprintf "%0.0f",$snp_sum/$num;
close IN;
if($in=~/.gz/) {open IN,"zcat $in|" or die $!;}  else{open IN,$in or die $!;}
$sum=0;
while(<IN>){
    chomp;
    my @s=split(/\s+/,$_);
    my $freq=$s[$order]*100;
    $sum+=($freq-$ave)*($freq-$ave);    
}
my $sd=sqrt($sum/($num-1));

my $sd_up=sprintf "%0.2f",$ave-1.96*$sd;
my $sd_down=sprintf "%0.2f",$ave+1.96*$sd;
$ave=sprintf "%0.2f",$ave;
$sd=sprintf "%0.2f",$sd;
#my ($sd_up,$sd_down)=($ave-1.96*$sd,$ave+1.96*$sd);
print "Avage and SD\t$ave $sd\n";
print "Observed number (Average)\t$snp_ave\n";
print "Observed proportion (95% CI)\t$ave ($sd_up to $sd_down)\n";
close IN;   

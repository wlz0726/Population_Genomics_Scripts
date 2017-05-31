#!/usr/bin/perl -w
use strict;

scalar @ARGV == 2 or die "Usage: perl $0 <tfam> <tped> \n";

my $famf = shift;
my $tped = shift;
my $outfile="treemix.input.gz";

my %pop = ();
my %poph = ();
my @pops = ();
open POP, $famf or die $!;
while (<POP>){
    chomp;
    my @t = split;
    my $group = $t[0];
    $pop{$t[1]} = $group;
    if (! defined $poph{$group}) {
	push @pops, $group;
	$poph{$group} = $group;
    }
}
close POP;

open(OUT,"|gzip -c > $outfile");
print OUT join(" ", @pops),"\n";

# read sample ID
open FAM, $famf or die $!;
my @samps = ();
while (<FAM>) {
    chomp;
    my @t = split;
    push @samps, $t[1];
}
close FAM;

# 
open TP, $tped or die $!;
while (<TP>) {
    chomp;
    my @t = split(/\s+/, $_);
    my %h = ();
    for (my $i = 4; $i < $#t; $i += 2) {
	my $samp = $samps[($i-4)/2];
	if (defined $pop{$samp}) {
	    $h{$t[$i]}++;
	    $h{$t[$i+1]}++;
	}
    }
    my @as = sort {$h{$a} <=> $h{$b}} keys %h;
    if (@as == 2) {
	my %count = ();
	for my $p (@pops) { $count{$p}{$as[0]} = 0; $count{$p}{$as[1]} = 0; }
	for (my $i = 4; $i < $#t; $i += 2) {
	    my $samp = $samps[($i-4)/2];
	    if (defined $pop{$samp}) {
		$count{$pop{$samp}}{$t[$i]}++;
		$count{$pop{$samp}}{$t[$i+1]}++;
	    }
	}
	my @outstr = ();
	for my $p (@pops) {
	    push @outstr, $count{$p}{$as[1]} . ',' . $count{$p}{$as[0]};
	}
	print OUT join(" ", @outstr),"\n";
    }
}
close TP;
close OUT;

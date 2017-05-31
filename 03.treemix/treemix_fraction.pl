#!/usr/bin/perl -w
use strict;

scalar @ARGV == 1 or die "Usage: perl $0 <stem>\n";

my $stem = shift;

my $covf = "$stem.cov.gz";  # W hat
my $mcovf = "$stem.modelcov.gz";# W

my @pops = ();

my %cov = ();
open IN1, "gzip -dc $covf |" or die $!;
while (<IN1>) {
	chomp;
	my @t = split;
	if ($. == 1) {
		@pops = @t;
		next;
	}
	my $p1 = $t[0];
	for my $i (1..$#t) {
		my $p2 = $pops[$i-1];
		$cov{$p1}{$p2} = $t[$i];
	}
}
close IN1;

my %mcov = ();
open IN2, "gzip -dc $mcovf |" or die $!;
while (<IN2>) {
	chomp;
	my @t = split;
	if ($. == 1) {
		@pops = @t;
		next;
	}
	my $p1 = $t[0];
	for my $i (1..$#t) {
		my $p2 = $pops[$i-1];
		$mcov{$p1}{$p2} = $t[$i];
	}
}
close IN2;

my %R = ();

for my $i (0..$#pops) {
	my $p1 = $pops[$i];
	for my $j (0..$#pops) {
		my $p2 = $pops[$j];
		$R{$p1}{$p2} =  $cov{$p1}{$p2} - $mcov{$p1}{$p2};
	}
}



my $f1 = get_mean_sq(\@pops, \%R);
my $f2 = get_mean_sq(\@pops, \%cov);

my $f = 1 - $f1/$f2;
my $fp = sprintf("%.2f%%", 100*$f);

print "The TreeMix ML tree explains $fp of the variation. $f\n";

sub get_mean_sq {
	my ($pop, $h) = @_;
	my $n = scalar @{$pop};
	my $sum = 0;
	my $m = $n * ($n - 1) * 0.5;
	for my $i (0..$n - 2) {
		for my $j ($i+1 .. $n-1) {
				$sum += $h->{$pop->[$i]}{$pop->[$j]};
		}
	}
	my $mean = $sum / $m;
	$sum = 0;
	for my $i (0..$n - 2) {
		for my $j ($i+1 .. $n-1) {
				$sum += ($h->{$pop->[$i]}{$pop->[$j]} - $mean) ** 2;
		}
	}
	return $sum;
}



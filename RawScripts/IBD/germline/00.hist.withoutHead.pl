#! /usr/bin/perl
use strict;
use warnings;

my $list=shift;
my $name=shift;
my $lim_min=shift;
my $lim_max=shift;
die "$0 histList Row(V1, V2 ,V3 ...) x_lim_min x_lim_max\n" unless $lim_max;
die "$0 histList Row(V1, V2 ,V3 ...)\n" unless ($name =~ /^V/);
open(OUT,"> $list.$name.$lim_min-$lim_max.Rscript");
print OUT "pdf(file=\"$list.$name.$lim_min-$lim_max.pdf\")\n";
print OUT "library(\"ggplot2\")\n";

print OUT "
a <- read.table(\"$list\",head=F)\n
#ggplot(a,aes(x=a\$$name))+geom_histogram(binwidth=0.01)+xlim(0,1)+xlab(\"$list\")+ylab(\"frequence\")\n
ggplot(a,aes(x=a\$$name))+geom_histogram(binwidth=10)+xlab(\"$list\")+ylab(\"frequence\")+xlim($lim_min,$lim_max)\n
";

print OUT "dev.off()\n";
close OUT;
`Rscript $list.$name.$lim_min-$lim_max.Rscript`;
`rm $list.$name.$lim_min-$lim_max.Rscript`;


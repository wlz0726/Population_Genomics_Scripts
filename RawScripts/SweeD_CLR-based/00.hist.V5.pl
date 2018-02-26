#! /usr/bin/perl
use strict;
use warnings;

my $list=shift;
my $name="V5";
die "$0 List RowName\n" unless $name;
open(OUT,"> $list.$name.Rscript");
print OUT "pdf(file=\"$list.$name.pdf\")\n";
print OUT "library(\"ggplot2\")\n";

print OUT "
a <- read.table(\"$list\",header=F)\n
ggplot(a,aes(x=a\$$name))+geom_histogram()+xlab(\"$list\")+ylab(\"frequence\")+xlim(c(0,100))\n
";

print OUT "dev.off()\n";
close OUT;
`Rscript $list.$name.Rscript`;
`rm $list.$name.Rscript`;

#! /usr/bin/perl
use strict;
use warnings;

my $list=shift;
my $name=shift;
die "$0 histList Row(V1, V2 ,V3 ...)\n" unless $name;
open(OUT,"> $list.$name.Rscript");
print OUT "pdf(file=\"$list.$name.pdf\")\n";
print OUT "library(\"ggplot2\")\n";

print OUT "
a <- read.table(\"$list\",head=F)\n
# log
ggplot(a,aes(x=log(a\$$name)/log(10)))+geom_histogram()+xlab(\"CNV length (log10)\")+ylab(\"Count\")
#+xlim(3,7)
#ggplot(a,aes(x=a\$$name))+geom_histogram()+xlab(\"CNV length\")+ylab(\"Count\")
";

print OUT "dev.off()\n";
close OUT;
`Rscript $list.$name.Rscript`;
`rm $list.$name.Rscript`;

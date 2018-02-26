#!/usr/bin/perl
use strict;
use warnings;
my $dir=shift;
die "$0 03.RFMix.V5.multiple.pl.out\n"unless $dir;

my @f=<$dir/*/*.rfmix.0.Viterbi.txt>;

open(O1,"> $0.$dir.1.sh");
open(O2,"> $0.$dir.2.sh");
foreach my $f(@f){
    print O1 "perl change.format.ggplot.pl $f;\n";
    print O2 "/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $f.r; convert -sample 500%x500% $f.pdf $f.png\n";
    open(R,"> $f.r");
    print R "library(ggplot2)
library(ggplot2)

a=read.table(gzfile(\"$f.ggdata.gz\"),header=F)

pdf(\"$f.pdf\",,width = 4.8, height = 2.5)

ggplot(a,aes(V1/1000000,V2))+geom_tile(aes(fill=factor(V3)))+scale_fill_manual(values=c(\"#A6CEE3\",\"#1F78B4\",\"#B2DF8A\",\"#33A02C\",\"#FB9A99\",\"#E31A1C\",\"#FDBF6F\"))+labs(x=\"Position (Mb)\",y=\"\",title=\"Chr1\")+theme_bw()+theme(axis.text.y=element_blank(),axis.ticks.y=element_blank(), legend.title= element_blank(),panel.grid =element_blank(),panel.grid.major=element_blank(),panel.grid.minor=element_blank(),  panel.border=element_blank(),axis.line.x = element_line(colour = \"black\",size = 0.3),legend.position = \"none\")

dev.off()

";
    close R;
    
}
close O1;
close O2;


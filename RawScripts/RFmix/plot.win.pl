#!/usr/bin/perl
use strict;
use warnings;
my $f=shift;
die "$0 03.RFMix.V3.pl.out/ChinaTau/ChinaTau.1.rfmix.0.Viterbi.txt.ggdata2.gz \n"unless $f;

open(O2,"> $f.plot.sh");
print O2 "/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $f.r; convert -sample 500%x500% $f.pdf $f.png\n";
open(R,"> $f.r");
print R "library(ggplot2)
library(ggplot2)

a=read.table(gzfile(\"$f\"),header=F)

pdf(\"$f.pdf\",,width = 4.8, height = 2.5)

ggplot(a,aes(V1*200000/1000000,V2))+geom_tile(aes(fill=factor(V3)))+scale_fill_manual(values=c(\"#E31A1C\",\"#1F78B4\"))+labs(x=\"Position (Mb)\",y=\"\",title=\" \")+theme_bw()+theme(axis.text.y=element_blank(),axis.ticks.y=element_blank(), legend.title= element_blank(),panel.grid =element_blank(),panel.grid.major=element_blank(),panel.grid.minor=element_blank(),  panel.border=element_blank(),axis.line.x = element_line(colour = \"black\",size = 0.3),legend.position = \"none\")

dev.off()

";
close R;
close O2;


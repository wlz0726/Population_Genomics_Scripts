my $f=shift;
die "$0 02.CountIBDLength.pl.*.out \n"unless $f;

open(O,"> $f.r");
print O "
library(pheatmap)

a=read.table(\"$f\")
a=as.matrix(a)
pdf(\"$f.cluster.pdf\",width=35,height=35,onefile=FALSE)
pheatmap(a)
dev.off()

pdf(\"$f.pdf\",width=35,height=35,onefile=FALSE)
pheatmap(a,cluster_rows=0,cluster_cols=0)
dev.off()


";
close O;

`/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $f.r`;
`rm $f.r`;

my $b=shift;
my $c=shift;
my $out="$0.out";
`rm $out`if -e $out;
open(R,"> $0.r");
print R "
b=read.table(\"$b\",header=F)
c=read.table(\"$c\",header=F)
cnv_number_b=b\$V2
cnv_number_c=c\$V2
Genetic_CNV_number_b=b\$V6
Genetic_CNV_number_c=c\$V6
CNV_gene_number_b=b\$V7
CNV_gene_number_c=c\$V7

p_cnv_number=wilcox.test(cnv_number_b,cnv_number_c)
p_Genetic_CNV_number=wilcox.test(Genetic_CNV_number_b,Genetic_CNV_number_c)
p_CNV_gene_number=wilcox.test(CNV_gene_number_b,CNV_gene_number_c)
head=paste(\"cnv_number\tGenetic_CNV_number\tCNV_gene_number\")
line=paste(p_cnv_number\$p.value,p_Genetic_CNV_number\$p.value,p_CNV_gene_number\$p.value)
write.table(head,file=\"$out\",append = TRUE,row.names=FALSE,col.names=FALSE,quote = FALSE);
write.table(line,file=\"$out\",append = TRUE,row.names=FALSE,col.names=FALSE,quote = FALSE);
";

`/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $0.r`;

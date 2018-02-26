
library("ggplot2");
library(RColorBrewer)
mycolor =brewer.pal(n=8, 'Set1')
mycolor2=c(mycolor[1:5],mycolor[7:8])

a=read.table(".ggplot2",header=T)
pdf(file=".PC1_PC2.pdf")
ggplot(a,aes(PC1,PC2,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=".PC1_PC3.pdf");
ggplot(a,aes(PC1,PC3,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=".PC1_PC4.pdf");
ggplot(a,aes(PC1,PC4,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=".PC2_PC3.pdf");
ggplot(a,aes(PC2,PC3,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=".PC2_PC4.pdf");
ggplot(a,aes(PC2,PC4,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=".PC3_PC4.pdf");
ggplot(a,aes(PC3,PC4,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

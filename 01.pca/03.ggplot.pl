my $f=shift;
my $out="$f.ggplot2";
open(I,"< $f");
<I>;
my @head=("FID");

for(my $i=1;$i<=4;$i++){
    my $h=PC."$i";
    push @head,$h;
}
push @head,"Populations";
push @head,"Regions";
my $head=join "\t",@head;
open(O,"> $out");
print O "$head\n";
while(<I>){
    chomp;
    s/^\s+//;
    my @a=split(/\s+/);
    $a[5] =~ /(\w\w)\-/;
    
    print O "$_\t$1\n";
}
close I;
close O;

open(R,"> $f.R");
print R "
library(\"ggplot2\");
library(RColorBrewer)
mycolor =brewer.pal(n=8, 'Set1')
mycolor2=c(mycolor[1:5],mycolor[7:8])

a=read.table(\"$f.ggplot2\",header=T)
pdf(file=\"$f.PC1_PC2.pdf\")
ggplot(a,aes(PC1,PC2,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=\"$f.PC1_PC3.pdf\");
ggplot(a,aes(PC1,PC3,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=\"$f.PC1_PC4.pdf\");
ggplot(a,aes(PC1,PC4,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=\"$f.PC2_PC3.pdf\");
ggplot(a,aes(PC2,PC3,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=\"$f.PC2_PC4.pdf\");
ggplot(a,aes(PC2,PC4,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()

pdf(file=\"$f.PC3_PC4.pdf\");
ggplot(a,aes(PC3,PC4,shape=Populations,color=Populations))+geom_point(size=3)+theme_bw()+scale_shape_manual(values=c(seq(0:18),seq(0,18),seq(0,18)))
dev.off()
";
close R;
`Rscript $f.R`;

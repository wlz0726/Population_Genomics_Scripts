my $f=shift;
my $max=shift;
die "$0 02.CountIBDLength.pl.*.out 642 \n"unless $max;
my $line=`cat $f|wc -l`;chomp $line;
my $npop=$line-1;
print "$npop\n";
open(O,"> $f.r");
print O "
dt <-read.table(\"$f\",header=T)
sample <- dt[,1]
npop <- $npop
pdf(\"$f.bar.pdf\")
par(mfrow=c(npop,1),mar=rep(1,4))
tem <- npop-1
for (i in c(1:tem)) {
  barplot(dt[,i+1],xlab=\"\",ylab=\"\",yaxt=\"n\",bty=\"o\",col=rainbow(npop),space=0.05,width=1,ylim=c(0,$max))
  mtext(sample[i], side = 2, line = 0,cex=1)
}
barplot(dt[,npop+1],xlab=\"\",ylab=\"\",yaxt=\"n\",bty=\"o\",col=rainbow(npop),space=0.05,width=1,names.arg=sample,cex.names=1.5,las=2,ylim=c(0,$max))
mtext(sample[npop], side = 2, line = 0,cex=1)
dev.off()
";
close O;

`/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $f.r`;
#`rm $f.r`;

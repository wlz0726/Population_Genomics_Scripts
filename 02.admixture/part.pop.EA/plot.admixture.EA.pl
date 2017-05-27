my $dir=shift;
my $plot_num=shift; # 2-10, 9plots
die "$0 dir\n"unless $dir;

#my $plot_num=9; # 2-10, 9plots
my $prefix="input.EA";


open(R,"> $dir/03.plot.r");
print R "pdf(\"$dir/03.plot.admixture.pdf\", width=6, height=6, bg=\"white\")
par(mfrow=c(10,1), mar=c(0,3,1.5,0.5), las = 0, mgp=c(0.5, 0.5, 0))

";

for(my $i=$plot_num+1;$i>2;$i--){
    my $color=$i+1;
    my $line=<<line;
pop<-read.table("$dir/02.poplist",as.is=T)
admix<-t(as.matrix(read.table("$dir/$prefix.$i.Q")))
admix<-admix[,order(pop[,3])]
pop<-pop[order(pop[,3]),]
barplot(admix,col=rainbow($color),space=0,border=NA,xlab="",ylab="K=$i",yaxt='n')

#position=c(0,tapply(1:nrow(pop),pop[,3],max))
#axis(1,at=position,labels=F)

line
print R "$line";
}

my $line=<<LINE;
pop<-read.table("$dir/02.poplist",as.is=T)
admix<-t(as.matrix(read.table("$dir/$prefix.2.Q")))
admix<-admix[,order(pop[,3])]
pop<-pop[order(pop[,3]),]
barplot(admix,col=rainbow(3),space=0,border=NA,xlab="",ylab="K=2",yaxt='n')

# axis
position=c(0,tapply(1:nrow(pop),pop[,3],max))
axis(1,at=position,labels=F)

# name
barplot(admix,col=c("white"),space=0,border=NA,xlab="",ylab=" ",xaxt='n', yaxt='n')
text(tapply(1:nrow(pop),pop[,3],mean),0.8,unique(pop[,1]),xpd=T,srt=90,cex=0.6)

dev.off()
LINE

    print R $line;



close R;

`Rscript $dir/03.plot.r`;

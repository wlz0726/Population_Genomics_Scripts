my $dir=shift;
die "$0 dir\n"unless $dir;

`grep CV $dir/*out > $dir/cv.txt`;
open(I,"$dir/cv.txt");
open(O,"> $dir/01.cv.error");
while(<I>){
    chomp;
    /log(\d+).out:CV error \(K=(\d+)\): ([\.\d]+)/;
    my $k=$1;
    my $k2=$2;
    my $cv=$3;
    #print "$k\t$k2\t$cv\n";
    print O "$k\t$cv\n";
}
close I;
close O;
`rm $dir/cv.txt`;

open(R,"> $dir/01.cv.error.r");
print R "library(ggplot2)
a=read.table(\"$dir/01.cv.error\",header=F)

pdf('$dir/01.cv.error.pdf',width=4.8,height=3)
ggplot(a,aes(x=V1,y=V2))+geom_line()+geom_point(size=1)+labs(x='K',y=\"CV error\")+scale_x_continuous(breaks=seq(0,20,1))+theme_bw()+theme(panel.grid.minor=element_blank())
dev.off()

";
`Rscript $dir/01.cv.error.r`;

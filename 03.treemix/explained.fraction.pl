my $dir=shift;
my $k=shift; # win
die "$0 dir k(1/100/500)\n"unless $dir;

`grep ML $dir/03.treemix.k$k.*tion > $dir/fraction.$k`;
open(I,"$dir/fraction.$k");
open(O,"> $dir/fraction.$k.txt");
while(<I>){
    chomp;
    #/log(\d+).out:CV error \(K=(\d+)\): ([\.\d]+)/;
    /\/03.treemix.k(\d+).(\d+)..*tion:The TreeMix ML tree explains .*% of the variation. (.*)$/;
    my $m=$2;
    my $frac=$3;
    print O "$m\t$frac\n";
}
close I;
close O;
`rm $dir/fraction.$k`;

open(R,"> $dir/fraction.$k.txt.r");
print R "library(ggplot2)
a=read.table(\"$dir/fraction.$k.txt\",header=F)

pdf('$dir/fraction.$k.txt.pdf',width=4.8,height=3)
ggplot(a,aes(x=V1,y=V2))+geom_line()+geom_point(size=1)+labs(x='Number of migration events',y=\"Proportion of the variance explained by the model\")+scale_x_continuous(breaks=seq(0,20,1))+theme_bw()+theme(panel.grid.minor=element_blank())
dev.off()

";
`Rscript $dir/fraction.$k.txt.r`;

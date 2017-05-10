my @f=@ARGV;
die "$0 outprefix 1.psmc 2.psmc ...
# change the gnuplot path of 'plot_psmc_MAR_SAT_SL.pl' first
# edit the script of the parameter (-u -g ... ) if you need ; '-u 9.796e-9 -g 5'
\n"unless @ARGV;
my @out;
my $out=shift(@f);
print "cat ";
for my $f(@f){
    $f =~/(.+)\.psmc/;
    my $id=$1;
    print " $f";
    push(@out,"$id");
}
print "> aa;\n";
print "
perl plot_psmc_MAR_SAT_SL.pl -M \"",join(",",@out),"\" -u 9.796e-9 -g 5 -x 10000 -X 10000000 -Y 400000 $out aa;
rm $out*txt $out*par *eps *epss aa* *Good;\n\n";



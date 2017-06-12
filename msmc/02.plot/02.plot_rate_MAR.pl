my @f=@ARGV;
die "$0 outprefix FLV_NEL.outfile.final.txt JBC_NEL.outfile.final.txt ...\n"unless @ARGV;
my @out;
my $out=shift(@f);
open(O,"> $0.$out.sh");
print O "cat ";
for my $f(@f){
    $f =~/(.+)\.outfile.final.txt/;
    my $id=$1;
    $id =~ s/_/-/;
    print O " $f";
    push(@out,"$id");
}
print O "> aa;\n";
print O "perl plot_rate_MAR.pl -M \"",join(",",@out),"\" -u 1.25e-8 -g 30 -x 1000 -X 100000 -Y 1.1 -R -P \"left top\" $out aa; rm *par aa* *Good *epss $out*txt;\n\n";
# rm $out*txt
#`sh $0.$out.sh`;

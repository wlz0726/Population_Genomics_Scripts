# note: sample id should less than 10 letters

my $prefix='input';

# software 
my $plink='/home/wanglizhong/software/plink/plink1.9/plink';
my $neighbor='/opt/blc/genome/biosoft/phylip-3.69/bin/neighbor';
#

open(O ,'>',"$0.01.njtree.sh");
print O "$plink --tfile $prefix --distance square 1-ibs flat-missing --out 2.dist\n";
print O "perl 02.mdist2phylip.pl 2.dist.mdist $prefix.tfam 3.phylip;\n";
print O "perl 03.phylip.pl 3.phylip 4.outfile 4.out.tree;\n";
print O "$neighbor 0<3.phylip.config;\n";
print O "mv outfile 4.outfile;\n";
print O "mv outtree 4.out.tree;\n";
close(O);


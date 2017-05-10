# v0.1
# date: 2017.4.21

# need:
# 1. input.tped input.tmap
# 2. *.plinklist with sub-individuals list in format: Pop_ID Sample_ID

my $prefix="input"; #prefix of input.tped input.tfam

open(O1,'>',"$0.1.pca.sh");
open(O2,"> $0.2.plot.sh");
`mkdir pdf`;
my @list=<*.plinklist>; # sample list
foreach my $list(@list){
    $list =~ /000.Ind.724.samplelist.id-pop.(.*).plinklist/;
    my $id=$1;
    my $head="$prefix.$id";
    my $dir2="$0.$id";
    `mkdir $dir2`;
    print O1 "/opt/blc/genome/biosoft/plink-1.07/plink --tfile $prefix --keep $list --out $dir2/input --recode --noweb;";
    print O1 "perl 02.MakeInd.pl $dir2/input.ped; ";
    open(PAR,"> $dir2/smartpca.par");
    print PAR "
# input
genotypename: $dir2/input.ped
snpname:      $dir2/input.map
indivname:    $dir2/input.pedind

# output
evecoutname:  $dir2/PCAout.evec
evaloutname:  $dir2/PCAout.eigenvalues

# optional parameters
numoutevec:      4
numoutlieriter:  0
altnormstyle:       NO
numoutlierevec:     10
outliersigmathresh: 6
qtmode:             0

# Multi-threading parameters
numthreads: 10

# output EIGENSTRAT files
outputformat:      EIGENSTRAT
genotypeoutname:   $dir2/input.EIGENSTRAT.geno
snpoutname:        $dir2/input.EIGENSTRAT.snp
indivoutname:      $dir2/input.EIGENSTRAT.ind
";
    close PAR;
    print O1 "export PATH=/home/wanglizhong/software/EIGENSOFT/EIG4.2/bin:\$PATH; /home/wanglizhong/software/EIGENSOFT/EIG4.2/bin/smartpca -p $dir2/smartpca.par > $dir2/smartpca.par.log 2>$dir2/smartpca.par.log2; \n";
    # ggplot plot
    print O2 "perl 03.ggplot.pl $dir2/PCAout.evec; ";
    # default plot of EIGENSOFT
    print O2 "perl /home/wanglizhong/software/EIGENSOFT/EIG4.2/bin/ploteig -i $dir2/PCAout.evec -c 1:2 -p $list.pop -o $dir2/PCAout.plot2.PC12.xtxt -x ;";
    print O2 "cp $dir2/PCAout.evec.PC1_PC2.pdf pdf/$id.PC1_PC2.pdf; ";
    # TW test of each PC
    print O2 "/home/wanglizhong/software/EIGENSOFT/EIG4.2/bin/twstats -t /home/wanglizhong/software/EIGENSOFT/EIG4.2/POPGEN/twtable -i $dir2/PCAout.eigenvalues -o $dir2/PCAout.eigenvalues.TWstatistics; \n";
    
}
close O;

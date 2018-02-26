# indicus taurus
my $Rscript="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript";
my $pythonbin="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/Python-2.7.8/bin";
my $pythonpath="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/Python-2.7.8";
my $rfmix="/home/wanglizhong/software/rfmix/RFMix_v1.5.4";
# link 
`ln -s ~/software/rfmix/RFMix_v1.5.4/RunRFMix.py .`;
`ln -s ~/software/rfmix/RFMix_v1.5.4/PopPhased .`;
`ln -s ~/software/rfmix/RFMix_v1.5.4/TrioPhased .`;
# adm pop: list in 03.Zangyi.pop
# source pop: M42_M51.pop;  CDX.pop; ITU.pop

my $out="$0.out";
`mkdir $out`unless -e $out;

open(O1,"> $0.1.sh");
open(O2,"> $0.2.sh");
open(O3,"> $0.3.sh");
open(O4,"> $0.4.sh");
open(I,"03.Zangyi.pop");
while(<I>){
    chomp;
    next if(/^\#/);
    my $pop=$_;
    #my $poplist="00.Seperate.pop.pl.out/target.pop/$pop.txt";
    #my $popnum=`less $poplist|wc -l`; chomp $popnum;
    
    my $out2="$out/$pop";
    `mkdir $out2`unless -e $out2;
    
    for($chr=1;$chr<=29;$chr++){
	print O1 "$Rscript $out/$pop/$pop.$chr.r;\n";
	open(R,"> $out/$pop/$pop.$chr.r");
	print R "
adm=read.table(gzfile((paste(\"02.seperate.pop.pl.out/$pop/\",$chr, \".bgl.gz\",sep=\"\"))),header=T, stringsAsFactors=F)
adm = adm[, -c(1:2)]
admT = t(adm)
numAdm = nrow(admT)


anc1 = read.table(gzfile((paste(\"02.seperate.pop.pl.out/indicus/\",$chr, \".bgl.gz\",sep=\"\"))),header=T, stringsAsFactors=F)
anc1 = anc1[, -c(1:2)]
anc1T = t(anc1)
numanc1 = nrow(anc1T)

anc2 = read.table(gzfile((paste(\"02.seperate.pop.pl.out/taurus/\",$chr, \".bgl.gz\",sep=\"\"))),header=T, stringsAsFactors=F)
anc2 = anc2[, -c(1:2)]
anc2T = t(anc2)
numanc2 = nrow(anc2T)

all = rbind(admT, anc1T, anc2T)

binarize = function(snp){
    asFactor = factor(snp)
    allele1 = levels(asFactor)[1]
    allele2 = levels(asFactor)[2]
    result = rep(NA, length(snp))
    result[snp == allele1] = '0'
    result[snp == allele2] = '1'
    return(result)
}

all01 = apply(all, 2, binarize)

# Transpose back
alleles = t(all01)

write.table(alleles, file=\"$out/$pop/$pop.$chr.alleles.txt\", quote=F, sep=\"\", col.names=F, row.names=F)


# Classes
classes = c(rep(0,numAdm), rep(1, numanc1), rep(2,numanc2))
classesM = matrix(classes, nrow=1)
write.table(classesM, file=\"$out/$pop/$pop.$chr.classes.txt\", quote=F, row.names=F, col.names=F)


";
	print O2 "export PATH=$pythonbin:\$PATH; export PYTHONPATH=$pythonpath:\$PYTHONPATH; $pythonbin/python2.7 $rfmix/RunRFMix.py PopPhased $out/$pop/$pop.$chr.alleles.txt $out/$pop/$pop.$chr.classes.txt 02.seperate.pop.pl.out/$pop/$chr.markers.locations2 -o $out/$pop/$pop.$chr.rfmix -n 5 --succinct-output --skip-check-input-format;\n";
	print O3 "perl region.pl 02.seperate.pop.pl.out/$pop/$chr.markers $out/$pop/$pop.$chr.rfmix.0.SNPsPerWindow.txt $out/$pop/$pop.$chr.rfmix.0.Viterbi.txt; perl plot.win.2.pl $out/$pop/$pop.$chr.rfmix.0.Viterbi.txt.withPos.gz; \n";
	print O4 "perl plot.win.3.normal.pl $out/$pop/$pop.$chr.rfmix.0.Viterbi.txt.withPos.gz;\n";
	close R;
    }
    
}
close I;
close O1;
close O2;
close O3;
close o4;

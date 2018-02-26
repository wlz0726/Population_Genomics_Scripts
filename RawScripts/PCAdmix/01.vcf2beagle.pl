my $vcftools="/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools";
my $java="/home/wanglizhong/software/java/jre1.8.0_45/bin/java";
my $java_home="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/java/jre1.8.0_45";
my $vcf2beagle="/home/wanglizhong/software/beagle/Utilities/vcf2beagle.jar";
# export JAVAHOME=/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/java/jre1.8.0_45;

my $out="$0.out";
`mkdir $out`unless -e $out;
open(O,"> $0.vcf2bgl.sh");
my @vcf=<00.vcf/*vcf.gz>;
my @indlist=<Ind.*.list>;
foreach my $indlist(@indlist){
    $indlist =~ /Ind.(.*).list/;
    my $pop=$1;
    my $out2="$out/$pop";
    `mkdir -p $out2`unless -e $out2;
    foreach my $vcf(@vcf){
	$vcf =~ /\/(\d+).vcf.gz/;
	my $chr=$1;
	print O "export JAVAHOME=$java_home; $vcftools --gzvcf $vcf --keep $indlist --recode -c | $java -jar $vcf2beagle -9 $out2/$chr;";
	print O "gunzip $out2/$chr.bgl.gz;\n";
    }
}
close O;


# vcf to plink file
open(O2,"> $0.vcf2plink.sh");
foreach my $vcf(@vcf){
    $vcf =~ /\/(\d+).vcf.gz/;
    my $chr=$1;
    
    print O2 "$vcftools --gzvcf $vcf --plink --out $vcf;";
    print O2 "perl AddGeneticDis.pl  $vcf.map /home/wanglizhong/project/01.cattle.CATwiwR/00.geneticMap/FakeLinkMap.pl.out/$chr.FakeLinkageMap.gz; perl fake.genetic.map.pl $vcf.map.map\n";
}
close O2;

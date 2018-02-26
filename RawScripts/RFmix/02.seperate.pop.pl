my $vcftools="/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools";
my $java="/home/wanglizhong/software/java/jre1.8.0_45/bin/java";
my $java_home="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/java/jre1.8.0_45";
my $vcf2beagle="/home/wanglizhong/software/beagle/Utilities/vcf2beagle.jar";


my $out="$0.out";
`mkdir $out`unless -e $out;

my @pop=<target.pop/*txt>;
my @vcf=<00.vcf/*vcf.gz>;

open(O1,"> $0.1.subPop.sh");
open(O2,"> $0.2.markers.sh");
foreach my $pop(sort @pop){
    $pop =~ /target.pop\/(.*).txt/;
    my $pop_id=$1;
    my $outdir="$out/$pop_id";
    `mkdir -p $outdir`unless -e $outdir;
    foreach my $vcf(sort @vcf){
	$vcf =~ /\/Chr(.*).phased.vcf.gz/;
	my $chr=$1;
	my $outprefix="$out/$pop_id/$chr";
	print O1 "export JAVA_HOME=$java_home;$vcftools --gzvcf $vcf --thin 1000 --keep $pop --recode -c |$java -jar $vcf2beagle -9 $outprefix; \n";
	#print O1 "perl markers.locations.pl $outprefix.markers ../00.geneticMap/03.FakeLinkMap.pl.out/$chr.FakeLinkageMap.gz;\n";
	print O2 "perl markers.locations.V2.pl $outprefix.markers;\n";

    }

}
close O1;
close O2;

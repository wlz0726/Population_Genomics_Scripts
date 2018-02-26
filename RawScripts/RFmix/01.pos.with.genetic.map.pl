my $out="$0.out";
`mkdir $out`unless -e $out;

open(O,"> $0.sh");
my @vcf=<../../../02.SNP/phased.combined1kg/chr*.vcf.gz>;
foreach my $vcf(@vcf){
    $vcf =~ /phased.combined1kg\/chr(.*).vcf.gz/;
    my $chr=$1;
    my $genetic_map = "../../../00.genetic.map/$chr.pos";
    my $outfile="$out/$chr.pos.gz";
    # only SNP with genetic map
    # remove singletons
    print O "/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools --gzvcf $vcf --positions $genetic_map --mac 2 --recode -c|gzip -c > $out/$chr.recode.vcf.gz;\n";
}
close O;

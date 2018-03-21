my $vcftools="/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools";
my $germline="/home/wanglizhong/software/germline/germline-1-5-1/germline";


my @vcf=<01.VCF/*vcf.gz>;
open(O,"> $0.sh");

foreach my $vcf(@vcf){
    print O "$vcftools --gzvcf $vcf --plink --out $vcf; ";
    print O "$germline -min_m 1 -bits 128 -err_hom 0 -err_het 4 < $vcf.run;\n";
    open(O2,"> $vcf.run");
    print O2 "1\n$vcf.map\n$vcf.ped\n$vcf.out\n";
    close O2;
}
close O;

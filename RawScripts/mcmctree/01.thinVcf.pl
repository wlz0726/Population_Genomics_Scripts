my $out="$0.out";
`mkdir $out`;

my @vcf=<0.1/*vcf.gz>;
open(O,"> $0.sh");
foreach my $vcf(@vcf){
    $vcf =~ /\/(\d+).vcf.gz/;
    my $chr=$1;
    #print "$chr\n";
    print O "/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools --gzvcf $vcf --keep sample.list --recode -c |gzip -c > $out/$chr.vcf.gz;\n";
}
close O;

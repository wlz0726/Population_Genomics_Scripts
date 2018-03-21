open(O,"> $0.sh");
my @vcf=<01.thinVcf.pl.out/*vcf.gz>;
foreach my $vcf(@vcf){
    print O "perl exon.vcf2fa.pl $vcf ;\n";
    print O "perl syn.vcf2fa.pl $vcf ;\n";
}
close O;


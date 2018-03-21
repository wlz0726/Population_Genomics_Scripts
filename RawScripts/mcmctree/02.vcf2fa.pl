

my @vcf=<01.thinVcf.pl.out/*vcf.gz>;
foreach my $vcf(@vcf){
    print "perl vcf2fa.pl $vcf ;\n";
    
}

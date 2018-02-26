my @f=</home/share/user/user104/projects/yak/association.Tianzhu/00.vcf/01.get.vcf.pl.out/*vcf>;

foreach my $f(@f){
    print "perl 01.run.sweed.g500.pl $f\n";
}

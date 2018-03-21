# 3137161264-239850802=2897310462
# mt genome 16338
my $dir=shift;
die "$0 CHB\n"unless $dir;
open(O,"> $0.$dir.sh");
my @bam=<$dir/*bam>;
foreach my $bam(sort @bam){
    print O "perl BamGenomeCoverageStatistics.pl $bam 16338 > $bam.GC;\n";
}
close O;

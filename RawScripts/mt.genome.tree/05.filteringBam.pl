my $out="$0.out";
`mkdir $out`unless -e $out;

open(O,"> $0.sh");
my @bam=<01.bowtie2.pl.out.rename.bam/*bam>;
foreach my $bam(@bam){
    $bam =~ /\/(.*).bam/;
    my $id=$1;
    print O "/home/wanglizhong/bin/samtools view -h $bam |perl filteringBam.pl | /home/wanglizhong/bin/samtools view -bS -o $out/$id.bam - ;/home/wanglizhong/bin/samtools index $out/$id.bam; export JAVAHOME=/home/wanglizhong/software/java/jre1.8.0_45; /ifshk4/BC_PUB/biosoft/PIPE_RD/Package/java/jre1.8.0_45/bin/java -Xmx5g -jar /home/wanglizhong/software/gatk/picard/picard.jar MarkDuplicates INPUT=$out/$id.bam OUTPUT=$out/$id.rmdup.bam METRICS_FILE=$out/$id.rmdup.txt REMOVE_DUPLICATES=true CREATE_INDEX=true; perl BamGenomeCoverageStatistics.pl $out/$id.rmdup.bam 16338 > $out/$id.rmdup.bam.GC; \n";
}
close O;

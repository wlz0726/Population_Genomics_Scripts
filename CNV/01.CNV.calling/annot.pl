my $bedtools=shift;
my $gene=shift;
my $bed=shift;
my $cnv=shift;


# cnv gene:  transcription units that are completely contained within genic CNVs.
`$bedtools intersect -a $gene -b $bed -f 1 > $cnv.CNVgene`;
`$bedtools intersect -a $gene -b $bed -f 0.8 > $cnv.CNVgene.0.8`;
`$bedtools intersect -a $gene -b $bed -f 0.5 > $cnv.CNVgene.0.5`;
# contain at least one whole transcription unit
`$bedtools intersect -a $bed -b $cnv.CNVgene -u > $cnv.geneticCNV`;
`$bedtools intersect -a $bed -b $cnv.CNVgene.0.8 -u > $cnv.geneticCNV.0.8`;
`$bedtools intersect -a $bed -b $cnv.CNVgene.0.5 -u > $cnv.geneticCNV.0.5`;

$cnv =~ /\/(.*).final.cnv/;
my $id=$1;

my $genetic_cnv="$cnv.geneticCNV";
my $cnv_gene="$cnv.CNVgene";

my $length_total=0;
my $count_total=0;
my $average_cnv_length;

my $count_deletion=0;
my $count_duplication=0;
my $count_genetic_cnv=`cat $genetic_cnv|wc -l`;chomp $count_genetic_cnv;
my $count_cnv_gene=`cat $cnv_gene|wc -l`;chomp $count_cnv_gene;
open(I,"$cnv");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $length_total +=$a[2];
    $count_total ++;
    
    if($a[0] =~ /deletion/){
	$count_deletion++;
    }elsif($a[0] =~ /duplication/){
	$count_duplication++;
    }
    
    
}
close I;

my $average_cnv_length=int($length_total/$count_total);
print "$id\t$count_total\t$average_cnv_length\t$count_deletion\t$count_duplication\t$count_genetic_cnv\t$count_cnv_gene\n";
# sample_id CNV_number average_length CNV_deletion_number CNV_duplication_number Genetic_CNV_number CNV_gene_number

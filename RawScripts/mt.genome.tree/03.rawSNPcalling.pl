my $samtools="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/samtools";
my $bcftools="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/bcftools/bcftools";
my $ref="MtRef/Bos.taurus.Ref.AF492351.1.fa";
my $bamlist="01.AllReadsBam2fq2bam.pl.out.bamlist";


my $out="$0.out";
`mkdir $out`;

open(O,"> $0.sh");
print O "$samtools mpileup -DSugf $ref -b $bamlist|$bcftools view -Ncg - > $out/mt.raw.vcf\n";
close O;

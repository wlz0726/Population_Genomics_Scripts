my $out="$0.out";
`mkdir $out`;
`mkdir tmp`;

open(O,"> $0.sh");
open(I," reads.list.fq1.txt");
while(<I>){
    chomp;
    /^(.*F13HTSNWKF0106_CATglqR\/([^\/]+)\/.*)\_1.fq.gz/;
    my $prefix=$1;
    my $id=$2;
    my $fq1=$_;
    my $fq2="$prefix\_2.fq.gz";
    #print "$prefix\t$id\n";
    print O "/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/bowtie2-2.2.5/bowtie2 -x /ifshk4/BC_COM_P5/F13HTSNWKF0106/CATwiwR/project/18.mt.genome/MtRef/Bos.taurus.Ref.AF492351.1.fa -1 $fq1 -2 $fq2 -q --phred64 --no-unal --sensitive-local -p 8| /home/wanglizhong/bin/samtools.1.3.1 sort -O bam -T ./tmp -o $out/$id.sort.bam; /home/wanglizhong/bin/samtools.1.3.1 index $out/$id.sort.bam;\n";
}
close I;
close O;

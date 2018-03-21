my @indicus=("BRM","GIR","NEL");
my @lqc=("LQC");
my @taurus=("JBC","RAN","FLV","HOL","LIM","JER");

# change this:
my @a=@taurus;
my @b=@indicus;

#
my $ref="/ifshk5/BC_COM_P11/F16RD04012/ICEmmrD/work/Cattle/step1.data/reference/UMD3.1.fasta";
my $samtools="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/samtools";
my $bcftools="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/bcftools/bcftools";
my $vcftools="/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools";
my $vcf2fq="/home/wanglizhong/tools/psmc/model12/vcf2fq.pl";
my $fq2psmcfa="/home/wanglizhong/software/psmc/psmc-0.6.5/utils/fq2psmcfa";
my $psmc="/home/wanglizhong/software/psmc/psmc-0.6.5/psmc";
my $vcfutils="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/bcftools/vcfutils.pl";
my $splitfa="/home/wanglizhong/software/psmc/psmc-0.6.5/utils/splitfa";

my $vcfdir="/ifshk5/BC_COM_P11/F16RD04012/ICEmmrD/work/Cattle/step2.phase/result/VCF";
#

my %h;
open(I,"PSMC.bam.list");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[0]}=$a[1];
}
close I;

my $out="$0.out";
`mkdir $out`unless -e $out;

open(O1,"> $0.step1.fq.sh");
open(O2,"> $0.step2.psmc.sh");

foreach my $a(@a){
    foreach my $b(@b){
	my $id1=$h{$a};
	my $id2=$h{$b};
	#print "$a\t$b\t$id1\t$id2\n";
	my $name="$a.$b";
	my $outdir="$out/$name";
	my $prefix="$out/$name/$name";
	`mkdir -p $outdir`unless -e $outdir;
	
	
	for(my $i=1;$i<=29;$i++){
	    my $vcf="$vcfdir/Chr$i.phased.vcf.gz";
	    print O1 "$vcftools --gzvcf $vcf --indv $id1 --indv $id2 --recode -c|perl Vcf2sampleTo1.pl |gzip -c > $prefix.Chr$i.vcf.gz;perl $vcf2fq $ref $prefix.Chr$i.vcf.gz Chr$i |gzip -c > $prefix.Chr$i.fq.gz;  $fq2psmcfa -q20 $prefix.Chr$i.fq.gz > $prefix.Chr$i.psmcfa;\n";
	}
	print O2 "cat $prefix.Chr*.psmcfa > $prefix.allchr.psmcfa; $psmc -N25 -t15 -r5 -p \"4+25*2+4+6\" -o $prefix.allchr.psmc $prefix.allchr.psmcfa;\n";
	
    }
}

close O1;
close O2;

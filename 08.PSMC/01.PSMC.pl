#!/usr/bin/perl
use strict;
use warnings;

# v0.3
# PSMC script
# created by wanglizhong
# 2017.6.14

my $bamlist="00.dep.pl.txt"; # each bam per line with four cols:Pop_name Sample_name Mean_Depth Bam_Path; Mean_Depth Bam_Path is unnecessary, can be replaced by '-'
die "$0 bamlist\n"unless $bamlist;

# related files and software ==================================
my $ref="/ifshk5/BC_COM_P11/F16FTSAPHT0404/RATxdeR/wanglizhong/SHEtbyR/13.psmc/reference/Oar_v3.1.chr.fa";
my $vcfdir="/ifshk5/BC_COM_P11/F16FTSAPHT0404/RATxdeR/wanglizhong/SHEtbyR/00.final.SNP.20170324/SNP/phasing";
# software
my $samtools="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/samtools";
my $bcftools="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/bcftools/bcftools";
my $vcftools="/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools";
my $vcf2fq="/home/wanglizhong/tools/pipeline/PSMC/bin/vcf2fq.V2.pl";
my $fq2psmcfa="/home/wanglizhong/software/psmc/psmc-0.6.5/utils/fq2psmcfa";
my $psmc="/home/wanglizhong/software/psmc/psmc-0.6.5/psmc";
my $vcfutils="/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/bcftools/vcfutils.pl";
my $splitfa="/home/wanglizhong/software/psmc/psmc-0.6.5/utils/splitfa";
# Note:
# change the method below before you use: # Three ways to get SNP info
#==============================================================

my $out="$0.out";
`mkdir $out`;

open (F,"$bamlist")||die"$!";
open(O1,"> $0.step1.fq.sh");
open(O2,"> $0.step2.psmc.sh");
open(O3,"> $0.step3.bt.sh");
open(O4,"> $0.step4.removeTMPfiles.sh");
while(<F>){
    chomp;
    #next if(/^=/ || /^-/);
    my @a=split(/\s+/);
    my $pop=$a[0];
    my $id=$a[1];
    #my $depth=20;
    #my $depth=$a[2];
    #my $bam=$a[3];
    
    `mkdir -p $out/$pop`;
    my $prefix="$out/$pop/$id";
    
    #my $mindepth=int($depth/3);
    #my $maxdepth=int($depth*3)+1;
    
    for(my $i=1;$i<=26;$i++){
	# Three ways to get SNP info
	
        # Method 1: de novo call SNP info; for samples with sequencing depth > 30 x
	# print O1 "$samtools mpileup -C50 -uf $ref -r Chr$i $bam | $bcftools view -c -  | $vcfutils vcf2fq -d $mindepth -D $maxdepth -Q 10 -l 5 |gzip -c > $prefix.Chr$i.fq.gz; $fq2psmcfa -q20 $prefix.Chr$i.fq.gz >$prefix.Chr$i.psmcfa;\n";
	
	# Method 2: based on unphased SNPs obtained with population data
	# my $vcf="/ifshk5/PC_HUMAN_EU/USER/zhuwenjuan/work/Cattle/step1.data/SNP/final.gatk.snp.Chr$i.VQSR.vcf.gz";
	
	# Method 3: based on phased SNPs; perfect for samples with low depth (<20x) in a relative large population;
	my $vcf="$vcfdir/chr$i.recode.vcf.gz";
	print O1 "$vcftools --gzvcf $vcf --indv $id --recode -c|gzip -c >  $prefix.Chr$i.vcf.gz; ";
	print O1 "$vcf2fq $ref $prefix.Chr$i.vcf.gz chr$i |gzip -c > $prefix.Chr$i.fq.gz; $fq2psmcfa -q20 $prefix.Chr$i.fq.gz > $prefix.Chr$i.psmcfa; \n";
	print O1 "rm $prefix.Chr$i.vcf.gz $prefix.Chr$i.fq.gz;\n";
	print O4 "rm $prefix.Chr$i.psmcfa; \n";
    }
    # running psmc
    print O2 "cat $prefix.Chr*.psmcfa > $prefix.allchr.psmcfa; $psmc -N25 -t15 -r5 -p \"4+25*2+4+6\" -o $prefix.allchr.psmc $prefix.allchr.psmcfa;\n";
    # running psmc with 100 bootstraps
    print O3 "$splitfa $prefix.allchr.psmcfa > $prefix.allchr.split.psmcfa ; mkdir -p $out/$pop/$id.bt; ";
    for(my $j=1;$j<=100;$j++){
	print O3 "$psmc -N25 -t15 -r5 -b -p \"4+25*2+4+6\" -o $out/$pop/$id.bt/$id.$j.psmc $prefix.allchr.split.psmcfa; ";
    }
    print O3 "cat $prefix.allchr.psmc $out/$pop/$id.bt/$id.*.psmc > $prefix.allchr.bootrstrap.psmc;\n";
}
close F;
close O1;
close O2;
close O3;
close O4;

#!/usr/bin/perl
use warnings;
use strict;
# add log and erro log compared with V3
# software setup
my $cnvnator="/home/wanglizhong/software/cnvnator/CNVnator_v0.2.7/src/cnvnator";
my $bin="1000";
die "$0 <bin_size>\n"unless $bin;

# input file is bamlist
my $in="bam.list";
die "$0 bamlist\n"unless $in;






my $present_dir=`pwd`;chomp $present_dir;
my $outdir="$present_dir/$0.$bin.out"; 
`mkdir -p $outdir`;

open(IN,"$in");
open(O1,">  $0.$bin.sh"); 
# step 1 : EXTRACTING READ MAPPING FROM BAM/SAM FILES;  memory consuming ; chrs seperated
# step 2 : GENERATING A HISTOGRAM; not memory consuming ; all chrs at once
# step 3 : CALCULATING STATISTICS; !!! This step must be completed before proceeding to partitioning and CNV calling.
# step 4 : RD SIGNAL PARTITIONING; most time consuming step
# step 5 : CNV CALLING
while(<IN>){
    chomp;
    my @s=split(/\t/,$_);
    my $tem=(split(/\//,$_))[-1];
    my $sample=(split(/\./,$tem))[0];
    my $bam=$_;
    
    my $cnv="$outdir/CNV/$sample"; 
    `mkdir -p $cnv`;
    
    my @files=<head.50k.split/*head.50k.s.*>;
    foreach my $f(sort @files){
	print O1 "export ROOTSYS=/home/wanglizhong/software/root/root-5.34.36;export LD_LIBRARY_PATH=/home/wanglizhong/software/root/root-5.34.36/lib:\$LD_LIBRARY_PATH;cd $cnv;";
	open(I1,"$f");
	while(<I1>){
	    chomp;
	    my $head=$_;
	    print O1 "$cnvnator -root $sample.$head.root  -unique -tree $bam -chrom $head 1>$sample.$head.root.l1 2>$sample.$head.root.e1;  ";
	    print O1 "$cnvnator -root $sample.$head.root  -d /ifshk5/PC_HUMAN_EU/USER/wanglizhong/projects/project.2.RATxdeR/ref/S.galili.v1.0.fa.split -his $bin -chrom $head 1>$sample.$head.root.l2 2>$sample.$head.root.e2;";
	    print O1 "$cnvnator -root $sample.$head.root -stat $bin -chrom $head 1>$sample.$head.root.l3 2>$sample.$head.root.e3;";
	    print O1 "$cnvnator -root $sample.$head.root -partition $bin -chrom $head 1>$sample.$head.root.l4 2>$sample.$head.root.e4;";
	    print O1 "$cnvnator -root $sample.$head.root -call $bin -chrom $head > $sample.$head.cnv 2>$sample.$head.root.e5;";
	}
	close I1;
	print O1 "\n";
    }
}
close IN;   
close O1;


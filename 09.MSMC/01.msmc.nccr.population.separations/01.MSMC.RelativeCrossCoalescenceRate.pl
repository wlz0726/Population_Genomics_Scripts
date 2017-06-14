#!/usr/bin/perl
use strict;
use warnings;

# Input and usage 
my ($ref,$bamlist,$vcflist,$poppair,$popinclude,$outdir)=@ARGV;
die "
Usage:
       perl $0 <ref> <bamlist> <vcflist> <poppair> <popinclude>[outdir]

       ref: reference genome with .fai index
   bamlist: 4 cols: 'Population Sample_id Average_depth file.bam'
   vcflist: 2 cols: '/path/to/Chr1.vcf.gz Chr1'
   poppair: 'PopA:PopB', one pair each line
popinclude: Two samples(4 haps) each Pop: 'PopA  SampleA  SampleB'
            or
            One samples(2 haps) each Pop: 'PopA  SampleA'
    outdir: Output directory [$0.out]

   NB: bamlist and popinclude can be redundancy; while file poppair are not redundancy and it defined the final pops(individuals)

4 steps:
1. generate bed and vcf file 
      bed: 1G, 1~10 hours
      vcf: 1G, 1~6 hours
2. PopA:PopB pair file
           1G, 
3. RCCR 
           250G, 10~15 days

"unless $popinclude;

# default set
$outdir ||="$0.out";

### configure =========================================================
my $vcftools='/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools';
my $samtools='/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/samtools';
my $bcftools='/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/samtools-0.1.19/bcftools/bcftools';
my $msmctools='/home/wanglizhong/software/msmc/msmc-master/tools';
my $msmc='/home/wanglizhong/software/msmc/msmc-master/build/msmc';
my $python='/opt/blc/python-3.1.2/bin/python3.1';
my $set_python='export LD_LIBRARY_PATH=/opt/blc/python-3.1.2/lib:$LD_LIBRARY_PATH';
###====================================================================

## read poppair
my %population;
open(I,"$poppair");
while(<I>){
    chomp;
    my @a=split(/\:/);
    $population{$a[0]}=1;
    $population{$a[1]}=1;
}
close I;

# read individual combination in popinclude
my %pop;
open(P,"$popinclude");
while(<P>){
    chomp;
    my @a=split(/\s+/);
    next if(!exists $population{$a[0]});
    #print "$a[1]\n$a[2]\n";
    $pop{$a[0]}{$a[1]}=1;
    $pop{$a[0]}{$a[2]}=1;
}
close P;

# read chr info in vcflist
my %chr;
open(CHR,"$vcflist");
while(<CHR>){
    chomp;
    my @a=split(/\s+/);
    $chr{$a[1]}=$a[0]; # chr_name  /path/to/vcf.vcf.gz
}
close CHR;

# read bamlist
# output bed.sh vcf.sh
open(O1,"> $0.1.bed.sh");
open(O2,"> $0.1.vcf.sh");
open(I1,"$bamlist");
while(<I1>){
    chomp;
    my ($pop,$id,$depth,$bam)=(split(/\s+/))[0,1,2,3];
    next unless(exists $pop{$pop}{$id}); # only deal with population/samples in popinclude list
    my $outpath="$outdir/01.Input/$pop/$id";
    `mkdir -p $outpath`unless -e $outpath;
    foreach my $chr(sort keys %chr){
	print O1 "$set_python; $samtools mpileup -q 20 -Q 20 -C 50 -u -r $chr -P ILLUMINA -f $ref $bam |$bcftools view -cgI - | $python $msmctools/bamCaller.py $depth $outpath/$id.$chr.mask.bed > $outpath/$id.$chr.raw.vcf;\n";
	print O2 "$vcftools --gzvcf $chr{$chr} --indv $id --max-missing 1 --recode --out $outpath/$id.$chr;\n";
    }
}
close I1;
close O1;
close O2;

# pop combination of poppair list
#my %poppair;
open(O3,"> $0.2.PopPair.sh");
open(O4,"> $0.3.RCCR.sh");
open(PP,"$poppair");
while(<PP>){
    chomp;
    my @a=split(/:/);
    my $pop1=$a[0];
    my $pop2=$a[1];
    my $name="$pop1-$pop2";
    my $outpath2="$outdir/02.Combine/$name";
    `mkdir -p $outpath2` unless -e $outpath2;
    my $outpath3="$outdir/03.Out";
    `mkdir -p $outpath3` unless -e $outpath3;
    
    my @pop1=keys %{$pop{$pop1}};
    my @pop2=keys %{$pop{$pop2}};
    my $sample_size=@pop1; # @pop1 must equal @pop2
    
    # You might want to reduce the resolution for some test runs to 30 segments (using e.g. -p 8*1+11*2), or even 20 segments (using e.g. -p 20*1)
    if($sample_size eq 1){
	print O4 "$msmc -R --skipAmbiguous -P '0,0,1,1' -o $outpath3/$name.nccr.4haps -i 50 -t 10 -p '15*1+15*2'";
    }elsif($sample_size eq 2){
	print O4 "$msmc -R --skipAmbiguous -P '0,0,0,0,1,1,1,1' -o $outpath3/$name.nccr.8haps -i 50 -t 10 -p '15*1+15*2'";
    }
    foreach my $chr(sort keys %chr){
	if($sample_size eq 1){
	    # $outdir/01.Input/$pop/$id:  $id.$chr.raw.vcf $id.$chr.mask.bed $id.$chr.recode.vcf
	    my $sample_1=$pop1[0];
	    my $mask_1="CHB_bed/NA18526.$chr.mask.bed";
	    #my $mask_1="$outdir/01.Input/$pop1/$sample_1/$sample_1.$chr.mask.bed";
	    my $vcf_1="$outdir/01.Input/$pop1/$sample_1/$sample_1.$chr.recode.vcf";
	    
	    my $sample_2=$pop2[0];
	    #my $mask_2=$mask_1;
	    #my $mask_2="$outdir/01.Input/$pop2/$sample_2/$sample_2.$chr.mask.bed";
	    my $vcf_2="$outdir/01.Input/$pop2/$sample_2/$sample_2.$chr.recode.vcf";
	    print O3 "$set_python; $python $msmctools/generate_multihetsep.py --mask $mask_1 $vcf_1 $vcf_2 > $outpath2/$name.$chr.txt; \n";
	    print O4 " $outpath2/$name.$chr.txt";
	}elsif($sample_size eq 2){
	    my $sample_1=$pop1[0];
	    my $sample_2=$pop1[1];
	    #my $mask_1="$outdir/01.Input/$pop1/$sample_1/$sample_1.$chr.mask.bed";
	    #my $mask_2="$outdir/01.Input/$pop1/$sample_2/$sample_2.$chr.mask.bed";
	    #my $mask_1="1KG_bed/chr$chr.mask.bed";
	    my $mask_1="CHB_bed/NA18526.$chr.mask.bed";
	    #my $mask_2=$mask_1;
	    
	    my $vcf_1="$outdir/01.Input/$pop1/$sample_1/$sample_1.$chr.recode.vcf";
	    my $vcf_2="$outdir/01.Input/$pop1/$sample_2/$sample_2.$chr.recode.vcf";
	    
	    my $sample_3=$pop2[0];
	    my $sample_4=$pop2[1];
	    #my $mask_3=$mask_1;
	    #my $mask_4=$mask_1;
	    #my $mask_3="$outdir/01.Input/$pop2/$sample_3/$sample_3.$chr.mask.bed";
	    #my $mask_4="$outdir/01.Input/$pop2/$sample_4/$sample_4.$chr.mask.bed";
            my $vcf_3="$outdir/01.Input/$pop2/$sample_3/$sample_3.$chr.recode.vcf";
            my $vcf_4="$outdir/01.Input/$pop2/$sample_4/$sample_4.$chr.recode.vcf";
	    print O3 "$set_python; $python $msmctools/generate_multihetsep.py --mask $mask_1 $vcf_1 $vcf_2 $vcf_3 $vcf_4 > $outpath2/$name.$chr.txt; \n";
	    print O4 " $outpath2/$name.$chr.txt";
	}else{
	    die "input file error:'popinclude'; or more than 2 samples in each populations\n";
	}
    }
    print O4 "\n";
}
close PP;
close O3;
close O4;

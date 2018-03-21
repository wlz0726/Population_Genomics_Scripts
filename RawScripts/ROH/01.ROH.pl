#  doi:10.1038/ng.3137
my $vcftools="/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools";
my $plink="/home/wanglizhong/bin/plink";


my $out="$0.out";
`mkdir $out`unless -e $out;

my @f=<00.in/*gz>;
open(O1,"> $0.1.vcf2tped.sh");
open(O2,"> $0.2.ROH.sh");
foreach my $vcf(@f){
    $vcf =~ /00.in\/(\d+).vcf.gz/;
    my $chr=$1;
    my $prefix=$vcf;
    
    
    print O1 "$vcftools --gzvcf $vcf --out $vcf --plink-tped ;\n";
    print O2 "$plink --noweb --tfile $prefix --homozyg --out $out/$chr --homozyg-window-kb 500 --homozyg-window-het 1 --homozyg-kb 1000 --homozyg-window-snp 100;\n";
#--homozyg-window-snp 50 --homozyg-snp 50 --homozyg-kb 100 --homozyg-density 50 --homozyg-gap 1000;\n ";
#   --homozyg-window-kb 500 --homozyg-window-snp 50 --homozyg-snp 50 --homozyg-kb 100 --homozyg-density 50 --homozyg-gap 1000 ;\n";
    
}
close O1;
close O2


# 
#--homozyg-window-kb 500 
#--homozyg-window-snp 50 (20,)
#--homozyg-snp 50 (10,)
#--homozyg-kb 100 (1000,)
#--homozyg-density 50 (200,)
#--homozyg-gap 1000 (4000)

# (1) doi:10.1038/gim.2015.139
# --homozyg-window-snp 20
# --homozyg-snp 10
# --homozyg-kb 1000
# --homozyg-density 200
# --homozyg-gap 4000
# --homozyg-window-missing 10
# --homozyg-window-threshold 0.05
# --homozyg-window-het 1

# (2) 
# --homozyg-window-kb 1000
# --homozyg-window-snp 500
# --homozyg-window-het 5
# --homozyg-window-missing 30


use strict;
use warnings;

my @vcf=<vcf/*.vcf.gz>;
my $num=@vcf;

my $now=$ENV{'PWD'};

my $step1="step1";

`mkdir $step1` if(!-e $step1); 

if(-e "$0.step1"){
    `rm -r $0.step1`;
}
`mkdir $0.step1`;
open(R1,"> $0.step1.sh");
my $i=0;
foreach my $vcf(@vcf){
    $i++;
    $vcf=~/\/([^\/]+)\.vcf.gz/;
    my $chr=$1;
    open(O1,"> $0.step1/$chr.r");
    print O1 "library(FastEPRR)\nFastEPRR_VCF_step1(vcfFilePath=\"$now\/$vcf\",winLength=\"10\", winDXThreshold=30,srcOutputFilePath=\"$now/$step1/$chr\")\n";
    close O1;
    
    print R1 "export LD_LIBRARY_PATH=/home/wanglizhong/lib:\$LD_LIBRARY_PATH; export R_LIBS=/ifshk7/BC_PS/wanglizhong/R:\$R_LIBS;/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $now/$0.step1/$chr.r\n";
}
close R1;


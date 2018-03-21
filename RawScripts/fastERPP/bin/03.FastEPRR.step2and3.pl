#! /usr/bin/env perl
use strict;
use warnings;

my @file=<step1/*>;
my $num=@file;

my $now=$ENV{'PWD'};

my $step1="step1";
my $step2="step2";
my $step3="step3";

`mkdir $step2` if(!-e $step2);
`mkdir $step3` if(!-e $step3);

if(-e "$0.step2"){
    `rm -r $0.step2`;
}
`mkdir $0.step2`;
open(R2,"> $0.step2.sh");
my $i=0;
foreach my $file(@file){
    $i++;
    $file=~/\/([^\/]+)$/;
    my $chr=$1;
    open(O2,"> $0.step2/$chr.r");
    print O2 "library(FastEPRR)\nFastEPRR_VCF_step2(srcFolderPath=\"$now/$step1/\",jobNumber=$num, currJob=$i, DXOutputFolderPath=\"$now/$step2\")\n";
    close O2;

    print R2 "export LD_LIBRARY_PATH=/home/wanglizhong/lib:\$LD_LIBRARY_PATH; export R_LIBS=/ifshk7/BC_PS/wanglizhong/R:\$R_LIBS; /ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $now/$0.step2/$chr.r\n";
}
close R2;

open(R3,"> $0.step3.Rscript");
print R3 "library(FastEPRR)\nFastEPRR_VCF_step3(srcFolderPath=\"$now/$step1\", DXFolderPath= \"$now/$step2\", finalOutputFolderPath=\"$now/$step3\")\n";
close R3;

open(O,"> $0.step3.sh");
print O "export LD_LIBRARY_PATH=/home/wanglizhong/lib:\$LD_LIBRARY_PATH; export R_LIBS=/ifshk7/BC_PS/wanglizhong/R:\$R_LIBS;/ifshk4/BC_PUB/biosoft/PIPE_RD/Package/R-3.1.1/bin/Rscript $now/$0.step3.Rscript\n";
close O;

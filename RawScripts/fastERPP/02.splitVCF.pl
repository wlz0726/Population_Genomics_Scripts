# you may want to change this
my @chr=(1..26);  
my $snpdir="/home/wanglizhong/project/03.sheep.SHEtbyR/01.Pop.Recombination.Rate/00.Data/pruningVCF";
# ---------------------------

open(O1,"> $0.1.sh");
open(O2,"> $0.2.sh");
open(O3,"> $0.3.sh");
open(O4,"> $0.4.sh");
#open(O5,"> $0.5.sh");

my @f=<Pop_*/*.txt>;
foreach my $f(@f){
    next if($f =~ /pl.txt/);
    $f =~/(.*)\/(.*).txt/;
    my $dir=$1;
    my $id=$2;
    `mkdir $dir/vcf`unless (-e "$dir/vcf");
    `cp bin/*pl $dir`;
    foreach my $chr(@chr){
        my $snp="$snpdir/chr$chr.vcf.gz";
	print O1 "/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools --gzvcf $snp --keep $f --non-ref-ac-any 1 --recode -c | gzip -c > $dir/vcf/$chr.vcf.gz;\n";
    }
    
    print O2 "cd $dir; perl 02.fastEPRR.pl; perl /home/wanglizhong/bin/buildSGESubmit.pl 02.fastEPRR.pl.step1.sh 0.6;perl /home/wanglizhong/bin/submit.pl z.02.fastEPRR.pl.step1.sh.z; cd ..;\n";
    # need this when deal genome with scaffolds
    # print O3 "cd $dir; perl remove_line1.pl;cd ..;";
    print O3 "cd $dir; perl 03.FastEPRR.step2and3.pl; perl /home/wanglizhong/bin/buildSGESubmit.pl 03.FastEPRR.step2and3.pl.step2.sh 1; perl /home/wanglizhong/bin/submit.pl z.03.FastEPRR.step2and3.pl.step2.sh.z; cd ..;\n";
    #print O4 "cd $dir; sh 03.FastEPRR.step2and3.pl.step3.sh;";
    #print O4 " perl 04.transFormat.pl;cd ..;\n";#perl 05.seperate.pl;cd ..;\n";
    print O4 "cd $dir;perl 05.seperate.pl;cd ..;\n";
}
close O1;
close O2;
close O3;
close O4;
#close O5;

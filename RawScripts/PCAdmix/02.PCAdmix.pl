my $out="$0.out";
`mkdir $out`unless -e $out;

# PCAdmix3_linux -anc LQC indicus taurus -adm ChinaTau -map 22.vcf.gz.map.map -rho 22.vcf.gz.map.map.genetic_map.txt -lab LQC indicus taurus ChinaTau -w 100 -bed 22 -out run4/out
my $pcadmix="/home/wanglizhong/bin/PCAdmix3_linux";

my $pwd=`pwd`; chomp $pwd;
open(O,"> $0.sh");
for(my $i=1;$i<=22;$i++){
    my $outdir="$out/$i";
    `mkdir -p $outdir`unless -e $outdir;
    my $anc0="$pwd/01.vcf2beagle.pl.out/LQC/$i.bgl";
    my $anc1="$pwd/01.vcf2beagle.pl.out/indicus/$i.bgl";
    my $anc2="$pwd/01.vcf2beagle.pl.out/taurus/$i.bgl";
    my $adm3="$pwd/01.vcf2beagle.pl.out/ChinaTau/$i.bgl";
    my $map="$pwd/00.vcf/$i.vcf.gz.map.map";
    my $rho="$pwd/00.vcf/$i.vcf.gz.map.map.genetic_map.txt";
    
    
    print O "cd $pwd/$outdir; $pcadmix -anc $anc0 $anc1 $anc2 -adm $adm3 -map $map -rho $rho -lab LQC indicus taurus ChinaTau -w 100 -bed $i -o chr$i;cd $pwd;\n";

}
close O;

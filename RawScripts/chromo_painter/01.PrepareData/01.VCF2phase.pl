# vcf to phase and recom_rate file 

my $out="$0.out";
`mkdir $out`;

my $geneticDir="/ifshk5/PC_HUMAN_EU/USER/wanglizhong/project.hk/201607.chromo_painter/CattleGeneticMap";

open(O,"> $0.1.sh");
open(O2,"> $0.2.sh");
my @f=</ifshk5/PC_HUMAN_EU/USER/zhuwenjuan/work/Cattle/step2.phase/result/VCF/*vcf.gz>; ###### vcf files
foreach my $f(@f){
    $f =~/VCF\/(Chr(.*)).phased.vcf/;
    my $chr=$1;
    my $chrnum=$2;
# vcf => plink12;  add genetic distance;    plink12 => chromopainter
    print O "/home/wanglizhong/software/vcftools/vcftools-build/bin/vcftools --gzvcf $f --plink --out $out/$chrnum.file; /home/wanglizhong/bin/plink --noweb --file $out/$chrnum.file --recode12 --out $out/$chrnum.plink12; perl AddGeneticDis.pl $out/$chrnum.plink12.map $geneticDir/$chrnum.FakeLinkageMap.gz;perl plink2chromopainter.pl -p=$out/$chrnum.plink12.ped -m=$out/$chrnum.plink12.map.map -o=$out/$chrnum.phase -r=$out/$chrnum.recomrate;\n";
}
print O2 "rm $out/*file* $out/*plink*\n";
close O;
close O2;

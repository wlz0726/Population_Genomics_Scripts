#perl AddGeneticDis.pl 01.VCF2phase.pl.out/25.plink12.map /ifshk5/PC_HUMAN_EU/USER/wanglizhong/project.hk/201607.chromo_painter/CattleGeneticMap/25.FakeLinkageMap.gz

my $map=shift;
my $geneticmap=shift;
my $out="$map.map";

my %h;
open(I1,"zcat $geneticmap|");
while(<I1>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[1]}=$a[3];
}
close I1;

open(I2,"$map");
open(O,"> $out");
while(<I2>){
    chomp;
    my @a=split(/\s+/);
    print O "$a[0]\t$a[1]\t$h{$a[3]}\t$a[3]\n";
}
close I2;
close O;

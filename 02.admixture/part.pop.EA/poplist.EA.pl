my $dir=shift;
die "$0 dir\n"unless $dir;

my $ped="$dir/input.EA.ped";
my %h;
open(I,"/home/wanglizhong/project/04.zangyi.F13FTSNWKF2248_HUMmuzR/02.SNP/phased.combined1kg/00.sites.with.genetic.map/03.prune/00.pop.order");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[0]}=$a[1];
}
close I;

`awk '{print \$1,\$2}' $ped > $ped.poplist`;
open(I,"$ped.poplist");
open(O,"> $dir/02.poplist");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    print O "$_\t$h{$a[0]}\n";
}
close I;
close O;

`rm $ped.poplist`;

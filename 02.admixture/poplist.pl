my $dir=shift;
die "$0 dir\n"unless $dir;
my $poporder="00.pop.order.par"; # two col: Pop_id order_num;  one pop each line 
die "need poporder.par file "unless -e $poporder;

my $ped="$dir/input.ped";
my %h;
open(I,"$poporder");
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

my $markers=shift;

open(I,"$markers");
open(O,"> $markers.locations2");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $tmp=$a[1]/1000000;
    print O "$tmp\n";
}
close I;
close O;

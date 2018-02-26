my $map=shift;
my $out="$map.genetic_map.txt";

open(I,"$map");
open(O,"> $out");
print O "position\tCOMBINED rate(cM/Mb)\tGenetic Map(cM)\n";
while(<I>){
    chomp;
    my @a=split(/\s+/);
    print O "$a[3]\t1\t$a[2]\n";

}
close I;
close O;

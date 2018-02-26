my $markers=shift;
my $genetic_map=shift;

my %h;
open(I,"$markers");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[1]}++;
    
}
close I;

open(I,"zcat $genetic_map|");
open(O,"> $markers.locations");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    if(exists $h{$a[1]}){
	print O "$a[3]\n";
    }

}
close I;
close O;

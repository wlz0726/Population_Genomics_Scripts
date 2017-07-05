my $bed=shift;
my $cnv=shift;

die "$0  bed cnv\n"unless $cnv;

my %h;
open(I,"$bed");
while(<I>){
    chomp;
    my $id=(split(/\s+/))[3];
    $h{$id}++;
}
close I;

open(I,"$cnv");
while(<I>){
    chomp;
    my $id=(split(/\s+/))[1];
    if(exists $h{$id}){
	print "$_\n";
    }
}
close I;

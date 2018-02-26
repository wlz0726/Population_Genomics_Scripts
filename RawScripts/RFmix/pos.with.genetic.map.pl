my $chr=shift;
my $vcf=shift;
my $genetic_map=shift;
my $outfile=shift;

my %h;

open(I,"$genetic_map");
<I>;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[0]}++;
}
close I;

open(I,"zcat $vcf|");
open(O,"|gzip -c > $outfile");
while(<I>){
    next if(/\#/);
    my @a=split(/\s+/);
    if(exists $h{$a[1]}){
	print O "$a[0]\t$a[1]\n";
    }
}
close I;
close O;

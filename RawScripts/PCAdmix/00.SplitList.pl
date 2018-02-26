open(I,"Ind.list");
my %h;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $h{$a[1]}{$a[0]}++;
}
close I;

foreach my $k1(sort keys %h){
    open(O,"> Ind.$k1.list");
    foreach my $k2(sort keys %{$h{$k1}}){
	print O "$k2\n";
    }
    close O;
}

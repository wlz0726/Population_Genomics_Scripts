my %h;
my @f=<../01.PSMC.pl.out/*/*.allchr.psmc>;
foreach my $f(@f){
    $f =~/out\/(.*)\/(.*)\.allchr.psmc/;
    $h{$1}{$2}=$f;
}

foreach my $k1(sort keys %h){
    #foreach my $k2(keys %{$h{$k1}}){
    my @a=sort keys %{$h{$k1}};
    for(my $i=0;$i<@a;$i++){
	my $num=$i+1;
	my $path=$h{$k1}{$a[$i]};
	`ln -s $path $k1\_$num.psmc`;
    }
}

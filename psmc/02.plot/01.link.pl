my @f=<../01.PSMC.pl.out/*/*psmc>;
foreach my $f(@f){
    $f =~ /01.PSMC.pl.out\/(.*)\/(.*).allchr.psmc/;
    my $id="$1.$2";
    print "ln -s $f $id.psmc\n";
}

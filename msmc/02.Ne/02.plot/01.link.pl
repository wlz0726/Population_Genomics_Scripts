my @f=<../group*/*/*final.txt>;
foreach my $f(@f){
    $f =~ /\/(\w+)\/\w+.outfile.final.txt/;
    `ln -s $f $1.txt`;
}

my $out="$0.out";
`mkdir $out`;

open(O,"> $0.sh");
my @pos=</ifshk5/BC_COM_P11/F16RD04012/ICEmmrD/work/Cattle/step2.anno/SNP/*.txt.gz>;
foreach my $pos(@pos){
    $pos =~ /\/chr(\w+).cow_multianno.txt.gz/;
    my $chr=$1;
    print O "perl pos.pl $pos $out/$chr;\n";

}
close O;

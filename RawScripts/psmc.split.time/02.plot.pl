my $out="$0.out";
`mkdir $out`;

open(O,"> $0.sh");
print O "cd $out;\n";
my %h;
my @f=<01.PSMC.pl.out/*/*.allchr.psmc>;
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
        #`ln -s $path $k1\_$num.psmc`;
	print O "ln -s ../$path $k1\_$num.psmc; \n";
    }
}
print O "cp /ifshk5/PC_HUMAN_EU/USER/wanglizhong/pipeline/PSMC/03.plot_psmc.pl .;\n";
print O "cp /ifshk5/PC_HUMAN_EU/USER/wanglizhong/pipeline/PSMC/*txt .;\n";
print O "cp /ifshk5/PC_HUMAN_EU/USER/wanglizhong/pipeline/PSMC/plot_psmc_MAR_SAT_SL.pl .;\n";
close O;

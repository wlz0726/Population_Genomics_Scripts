my @psmc=@ARGV;
die "$0 1.bt.psmc 2.bt.psmc ... n.bt.psmc\n"unless @ARGV;
open(OUT,"> $0.gp");
foreach my $psmc(@psmc){
    `perl psmc_plot.g3.pl -R $psmc $psmc`;
}

print OUT "
  set size 1, 0.8;
  set xran [10000:*];
  set log x;
  set format x \"10^{%L}\";
  set mxtics 10;
  set mytics 10;
  unset grid;
  set key right top;
  set xtics font \"Helvetica,16\";
  set ytics nomirror font \"Helvetica,16\";
  set xlab \"Years (g=3, {/Symbol m}=5.84x10^{-9})\" font \"Helvetica,16\";
  set t po eps enhance so co \"Helvetica,16\";

  set yran [0:20];
  set ylab \"Effective population size (x10^4)\" font \"Helvetica,16\";

  set out \"$0.eps\";
  set style line 1 lt 1 lc rgb \"#2166AC\" lw 4;
  set style line 2 lt 1 lc rgb \"#BB8F00\" lw 4;
  set style line 3 lt 1 lc rgb \"#0080FF\" lw 4;
  set style line 4 lt 1 lc rgb \"#BF00FF\" lw 4;
  set style line 5 lt 1 lc rgb \"#F88700\" lw 4;
  
  set style line 6 lt 1 lc rgb \"#C04000\" lw 4;
  set style line 7 lt 1 lc rgb \"#C8C800\" lw 4;
  set style line 8 lt 1 lc rgb \"#FF80FF\" lw 4;
  set style line 9 lt 1 lc rgb \"#4E642E\" lw 4;
  set style line 10 lt 1 lc rgb \"#800000\" lw 4;

  set style line 11 lt 1 lc rgb \"#67B7F7\" lw 4;
  set style line 12 lt 1 lc rgb \"#FFC127\" lw 4;

  set style line 21 lt 1 lc rgb \"#A1D1FF\" lw 1;
  set style line 22 lt 1 lc rgb \"#FFE180\" lw 1;
  set style line 23 lt 1 lc rgb \"#A1D1FF\" lw 1;
  set style line 24 lt 1 lc rgb \"#EDBFFA\" lw 1;
  set style line 25 lt 1 lc rgb \"#FFE180\" lw 1;

  set style line 26 lt 1 lc rgb \"#c7eae5\" lw 1;
  set style line 27 lt 1 lc rgb \"#dfc27d\" lw 1;
  set style line 28 lt 1 lc rgb \"#d6604d\" lw 1;
  set style line 29 lt 1 lc rgb \"#74c476\" lw 1;
  set style line 20 lt 1 lc rgb \"#74a9cf\" lw 1;
  plot ";
my $num=1;
my @head;
foreach my $psmc(@psmc){
    $psmc =~ /(.*)\.psmc/;
    my $id=$1;
    open(IN,"$psmc.gp");
    while(<IN>){
        next if (!/plot/);
        chomp;
        $_ =~ s/\s+plot//;
        $_ =~ s/;//;
        
        my @a=split(/,/);
        my @a2;
        my $head;
        $a[-1] =~ s/ls \d/ls $num/;
        $a[-1] =~ s/\"popsize\"/\"$id\"/;
        $head= $a[-1];
        push (@head,$head);
        for(my $i=0;$i<@a-1;$i++){
            if($a[$i] =~ /popsize/){
	$a[$i] =~ s/ls \d/ls 2$num/;
            }else{
	$a[$i]=~ s/ls \d/ls 2$num/;
            }
            push (@a2,$a[$i]);
        }
        my $a2=join ",",@a2;
        print OUT "$a2, ";
        $num++;
    }
}
my $head=join ",",@head;
print OUT "$head;";

close OUT;
`gnuplot $0.gp`;
`epstopdf.pl $0.eps`;
`rm *txt *par *eps`;
`rm *gp`;


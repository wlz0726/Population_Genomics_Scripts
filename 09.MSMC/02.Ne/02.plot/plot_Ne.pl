#!/usr/bin/perl -w

# Author: lh3

use strict;
use warnings;
use Getopt::Std;

my $version = "0.2.0";

my %opts = (u=>2.5e-8, 's'=>100, Y=>0, m=>5, X=>0, M=>'', x=>1000, y =>1000,n=>20, g=>25, f=>"Helvetica,22",
        w=>4, P=>"right top", T=>'');
getopts('x:y:u:s:X:Y:RGpm:n:M:N:g:f:w:P:T:', \%opts);
die("
        Usage:   msmc_plot.pl [options] <out.prefix> <in.psmc>\n
        Options: 
        -u FLOAT   absolute mutation rate per nucleotide [$opts{u}]
        -s INT     skip used in data preparation [$opts{s}]
        -X FLOAT   maximum generations, 0 for auto [0]
        -x FLOAT   minimum generations, 0 for auto [$opts{x}]
        -y FLOAT   minimum generations, 0 for auto [$opts{y}]
        -Y FLOAT   maximum popsize, 0 for auto [$opts{Y}]
        -m INT     minimum number of iteration [$opts{m}]
        -n INT     take n-th iteration (suppress GOF) [$opts{n}]
        -M titles  multiline mode [null]
        -f STR     font for title, labels and tics [$opts{f}]
        -g INT     number of years per generation [$opts{g}]
        -w INT     line width [$opts{w}]
        -P STR     position of the keys [$opts{P}]
        -T STR     figure title [null]
        -p         convert to PDF (with epstopdf)
        -R         do not remove temporary files
        -G         plot grid
        \n") if (@ARGV < 2);
#$opts{M}=1 ;
my $prefix = shift(@ARGV);
my $result = shift(@ARGV);
my (@data, $d, $N0, $skip, $Mseg, $Msize, $id, $min_ri, $do_store, $gof, $round, @FN, @nscale, @tscale, @alpha, $dt);
# load data
my ($max_seg, $max_size, $fh);
$max_seg = $max_size = 0;
open IN,$result or die $!;
my $i='N';
while(<IN>){
    chomp;
    my @a=split;
    my $line=$_;
    my ($index,$left_time,$right_time,$lambda_00)=(@a)[0,1,2,3];
    if($line=~/time_index/ && $i eq 'N') {
        $i=0;
        if( -e "$prefix.$i.txt") {`rm $prefix.$i.txt`;}
        open TEM,'>>',"$prefix.$i.txt" || die;
        next;
    }
    elsif($line=~/time_index/){
        $i++;
        close TEM;
        if( -e "$prefix.$i.txt") {`rm $prefix.$i.txt`;}
        open TEM,'>>',"$prefix.$i.txt" || die;
        next;
    }
    else{;}
    my $real_time            = $left_time/$opts{u}*$opts{g};
    my $real_population_size = 1/$lambda_00/(2*$opts{u});
    print TEM "$real_time\t$real_population_size\n";
}
close TEM;
close IN;
my $i_sum=$i;
# plot

#my $y2tic = int($max_seg / 11.0 / 100.0 + 0.5) * 100;
#my $y2ran = $max_seg * 11.0 / 10.0;
my $yran = ($opts{Y} > 0)? $opts{Y}: '*';
my $xran = ($opts{X} > 0)? $opts{X}: '*';
my $keyconf = $opts{M}? "set key $opts{P}" : "set key off";
my $grid = $opts{G}? "set grid" : 'unset grid';
my $afont = qq/font "$opts{f}"/;
my $lw = qq/lw $opts{w}/;
my $ylab_aux = sprintf("%.2fx10^{-8}", $opts{u}/1e-8);

my $gunbin = "/ifshk5/PC_HUMAN_EU/USER/zhuwenjuan/bin/software/gnuplot-4.6.0/bin/gnuplot";
open($fh, "| tee $prefix.gp | $gunbin ") || die;
print $fh qq(
set size 1, 0.81;
set xran [$opts{x}:$xran];
set log x;
set format x "10^{\%L}";
set yran [$opts{y}:$yran];
set log y;
set format y "10^{\%L}";
set mxtics 10;
set mytics 10;
$grid;
$keyconf;
set xtics $afont;
set ytics nomirror $afont;
set xlab "Years ago (g=$opts{g}, {/Symbol m}=$ylab_aux)" $afont;
  set t po eps enhance so co "Helvetica,20";
  );
#  my $AADD=$yran/10 ;
  print $fh qq/set title "$opts{T}";/ if ($opts{T});
  print $fh qq(
  #set yran [-8:$yran];
  #set yran [0:$yran];
  set ylab "Effective population size" $afont;  #(x10^4)
  #set key default
  set out "$prefix.eps";
  set style line 1 lt 1 lc rgb "#FF0000" $lw;
  set style line 2 lt 2 lc rgb "#00C000" $lw;
  set style line 3 lt 3 lc rgb "#0080FF" $lw;
  set style line 4 lt 4 lc rgb "#C000FF" $lw;
  set style line 5 lt 5 lc rgb "#00EEEE" $lw;
  set style line 6 lt 6 lc rgb "#C04000" $lw;
  set style line 7 lt 7 lc rgb "#C8C800" $lw;
  set style line 8 lt 8 lc rgb "#FF80FF" $lw;
  set style line 9 lt 9 lc rgb "#4E642E" $lw;
  set style line 10 lt 10 lc rgb "#800000" $lw;
  set style line 11 lt 11 lc rgb "#67B7F7" $lw;
  set style line 12 lt 12 lc rgb "#FFC127" $lw;
  set style line 13 lt 13 lc rgb "#FFC0C0" $lw;

#  set style line 1 lt 1 lc rgb "#FF0000" $lw;
#  set style line 2 lt 2 lc rgb "#00C000" $lw;
#  set style line 3 lt 3 lc rgb "#0080FF" $lw;
#  set style line 4 lt 4 lc rgb "#C000FF" $lw;
#  set style line 5 lt 5 lc rgb "#00EEEE" $lw;
#  set style line 6 lt 6 lc rgb "#C04000" $lw;
#  set style line 7 lt 7 lc rgb "#C8C800" $lw;
#  set style line 8 lt 8 lc rgb "#FF80FF" $lw;
#  set style line 9 lt 9 lc rgb "#000000" $lw;

  set key default
  plot );

my $zwj_i=2;  
  if ( $opts{M}) {
          my @titles = split(/[\,\;]/, $opts{M});
          print $fh qq("$prefix.0.txt" u 1:2 t "$titles[0]" w st ls 1);
          foreach my $i (1 .. $i_sum) {
                  print $fh qq(,"$prefix.$i.txt" u 1:2 t "$titles[$i]" w st ls $i + 1);
          }
#          print $fh qq("$prefix.0.txt" u 1:2 t "$titles[0]" w st ls 1);
          print $fh qq(;\n);

  } else {
      print $fh qq("$prefix.0.txt" u 1:2 t "popsize" w st ls 1);      
          foreach my $i (1 .. $i_sum-1) { 
              print $fh qq(,"$prefix.$i.txt" u 1:2 w  st ls $zwj_i ); 
              $zwj_i++;

          }
          #foreach my $i (1 .. @data-1) { print $fh qq("$prefix.$i.txt" u 1:2 w st not 2,)}
#          print $fh qq("$prefix.0.txt" u 1:2 t "popsize" w st ls 1);
          print $fh qq(;\n);   
      }
  #print $fh qq("data" u 1:2  w st ls 4,);
#  print $fh qq("data.10000.value" u 1:3  w st ls 6);
#  print $fh qq(;\n);
 
  
  close($fh);

  #if (defined $opts{p}) {
  #        system("epstopdf $prefix.eps");
  #}

    system ("convert  $prefix.eps  $prefix.pdf  ") ;
# remove files
#  unless (defined($opts{R})) {
unlink <$prefix.*.txt>; unlink "$prefix.gp"; unlink "$prefix.Good";
unlink "$prefix.eps" ;
#  }
#if ($opts{M}) 
#          {
unlink <*.par>;
#          }

#!/usr/bin/perl

=head1 Name

 run_mcmctree.pl - divergence time estimation with PAML mcmctree

=head1 Version

 Author: wangzhuo@genomics.org.cn;
         xiaofei@genomics.org.cn;
 Version 1.1, last change: 2010-09-29

=head1 Usage

 perl run_mcmctree.pl <in.phy> <in.tree> [options]
  <in.phy>           sequential phylip format nucleotide sequences
  <in.tree>          newick format rooted tree with calibration time

 Commonly used options:
  --outdir <dir>     output results to this directory, default ./
  --desc <file>      species mark, scientific, [common names] (tab delimited)
  --rootage <num>    the root node age of input tree is less than this value,
                      default 100 (mya)
  --alpha <num>      alpha value for gamma distribution of rates across sites,
                      default 0

 Other options:
  --nsample <num>    the number of samples for MCMC process, default 100000
  --burnin <num>     the number of samples be dicarded, default 10000
  --clock <num>      which molecular clock model to be used, default 3
                      1:global clock; 2:independent rates; 3:correlated rates
  --model <num>      nucleotide substitution model, default 0
                      0:JC69, 1:K80, 2:F81, 3:F84, 4:HKY85 
  --finetune="<str>" finetune for MCMC process, default "0.05 0.1 0.12 0.1 0.3"
  --clean            delete temporary files
  --help             show help information

=head1 Example

 perl run_mcmctree.pl in.phy in.tree --desc in.desc --rootage 120

=cut

use strict;
use Getopt::Long;
use Cwd qw(abs_path);
use FindBin qw($Bin);
use lib "$Bin";

my $mcmctree = "$Bin/programs/mcmctree";
my $mcmctree_ft = "$Bin/programs/mcmctree_ft";
my $drawtree = "perl $Bin/draw_tree.pl";
my ($output, $clock, $model, $burnin, $nsample, $rootage, $alpha, $indesc) 
	= (".", 3, 0, 10000, 100000, 100, 0, "");
my ($help, $clean);
my $finetune = "0.05 0.1 0.12 0.1 0.3";
GetOptions(
    "outdir:s"  => \$output,
    "desc:s"   => \$indesc,
    "clock:i"   => \$clock,
    "model:i"   => \$model,
    "burnin:i"  => \$burnin,
    "nsample:i" => \$nsample,
    "rootage:f" => \$rootage,
    "alpha:f" => \$alpha,
    "clean"    => \$clean,
    "help"    => \$help,
);

die `pod2text $0` if (@ARGV != 2 || $help);

$rootage /= 100;
$rootage = sprintf "%.1f", $rootage;
$output =~ s/\/+$//;
mkdir $output if (not -e $output);
$output = abs_path($output);

my $input     = shift;
my $time_tree = shift;
$input = abs_path($input);
$time_tree = abs_path($time_tree);

# Read in tree/phy file;
open IN, "$time_tree" or die "Can't open file $time_tree: $!";
my $tmpstr = <IN>;
$/ = ";";
my $treestr = <IN>;
close IN;
$/ = "\n";
$treestr = "$tmpstr $treestr" if ($tmpstr !~ /^[\d\s]+$/);

my $newtree = $treestr;
$newtree =~ s/\'[\d\.\s\>\<]+\'//g;
my @spnames;
push @spnames, $1 while ($newtree =~ m/[(),\s]*([\w]+)[(),\s]+/g);
my $spnum = @spnames;

open IN, "$input" or die "Can't open file $input: $!";
<IN>;
my %seqs;
while (<IN>) {
	chomp; my @arr = split /\s+/;
	$seqs{$arr[0]} = $arr[1];
}
close IN;

my $seqnum = 0;
open OUT, ">$output/tmp.phy" or die "Can't write to file $output/tmp.phy: $!\n";
my $seqlen = length($seqs{$spnames[0]});
print OUT "   $spnum   $seqlen\n";
foreach (@spnames) {
	if (exists $seqs{$_}) {
		print OUT "$_   $seqs{$_}\n";
		$seqnum++;
	}
}
close OUT;

if ($seqnum == $spnum) {
	open OUT, ">$output/tmp.tree" or die "Can't write to file $output/tmp.tree: $!\n";
	print OUT "   $spnum   1\n$treestr\n";
	close OUT;
}
else {
	die "Some species exists in tree file are not exists in sequence file.\n";
}

# Decide finetune parameters;
write_ctl($output, $clock, $rootage, $model, $alpha, $finetune, 4000, 20000, 2);
my $cwd = Cwd::getcwd();
chdir $output;
my @arr1 = `$mcmctree_ft mcmctree.ctl`;
chdir $cwd;
while (my $line = shift @arr1) {
	if ($line =~ /^Information\ for\ finetune/) {
		unshift @arr1, $line;
		last;
	}
}
print join("", @arr1);

shift @arr1; shift @arr1;
$finetune = "";
foreach (@arr1) {
	my @arr2 = split /:/, $_;
	my @arr3 = split /[\>\(\)\,]+/, $arr2[0];
	if ($arr2[1] =~ /should\ be\ reset|can\ be\ unchanged\ or\ reset/) {
		$arr3[-1] =~ s/\s+//g;
		$finetune .= "$arr3[-1] ";
	}
	else {
		$arr3[1] =~ s/\s+//g;
		$finetune .= "$arr3[1] ";
	}
}

print "\nNew finetune paras: $finetune\n";
print "Go on with new finetune parameters or not(<Ctrl> + C to stop)?\n";
sleep 15;

# Perform mcmc;
my $sampfreq = 2;
$burnin *= $sampfreq;
print "MCMC run for ", ($nsample * $sampfreq), " times, ",
	"$burnin times are discarded before sampling.\n";
write_ctl($output, $clock, $rootage, $model, $alpha, $finetune, $burnin, $nsample, $sampfreq);
my $cwd = Cwd::getcwd();
chdir $output;
system "$mcmctree mcmctree.ctl";
chdir $cwd;


# Extract tree information & output to file;
open(IN, "$output/mcmctree.out") or die "Can't open file $output/mcmctree.out: $!\n";
while (<IN>) {
	if (/^Species/) {
		open (OUT, ">$output/divtree.newick") 
			or die "Can't write to file $output/divtree.newick: $!\n";
		my $line1 = <IN>;
		my $line2 = <IN>;
		$line2 = <IN>;
		my ($a, $b);
		$line2 =~ s/:\s+([\d\.]+)/$a=$1*100; ":$a";/ge;
		print OUT "$line2";
		my $line3 = <IN>;
		$line3 = <IN>;
		$line3 =~ s/:\s+([\d\.]+)/$a=$1*100; ":$a";/ge;
		$line3 =~ s/\'([\d\.]+)-([\d\.]+)\'/$a=$1*100; $b=$2*100; "\'$a-$b\'";/ge;
		print OUT "$line3";
		close OUT;
		last;
	}
}
close IN;

my $num = `wc -l $output/mcmctree.out`;
print "Original result:\n $output/mcmctree.out\n" if ($num > 0);
my $num = `wc -l $output/divtree.newick`;
print "Divergence-time tree(Mya):\n $output/divtree.newick\n" if ($num > 0);

if ($indesc eq "" || !-e $indesc) {
	`touch $output/tmp.desc`;
	$indesc = "$output/tmp.desc";
}
`$drawtree $output/divtree.newick $indesc -cali $time_tree > $output/divtree.svg`;

`rm SeedUsed mcmc.out $output/tmp.tree` if ($clean);
`rm $output/mcmctree.ctl` if ($clean);


sub write_ctl {
	my ($output, $clock, $rootage, $model, $alpha, $finetune, $burnin, $nsample, $sampfreq) = @_;

	my $ctl = <<END;
         seed =  -1
      seqfile =  $output/tmp.phy
     treefile =  $output/tmp.tree
      outfile =  $output/mcmctree.out
        ndata =  1
      usedata =  1    * 0: no data; 1:seq like; 2:use in.BV; 3: out.BV
        clock =  $clock    * 1: global clock; 2: independent rates; 3: correlated rates
      RootAge =  <$rootage  * safe constraint on root age, used if no fossil for root.
        model =  $model    * 0:JC69, 1:K80, 2:F81, 3:F84, 4:HKY85
        alpha =  $alpha    * alpha for gamma rates at sites
        ncatG =  4    * No. categories in discrete gamma
    cleandata =  0    * remove sites with ambiguity data (1:yes, 0:no)?
      BDparas =  1 1 0    * birth, death, sampling
  kappa_gamma =  6 2      * gamma prior for kappa
  alpha_gamma =  1 1      * gamma prior for alpha
  rgene_gamma =  2 2   * gamma prior for overall rates for genes
 sigma2_gamma =  1 10    * gamma prior for sigma^2     (for clock=2 or 3)
     finetune =  $finetune  * times, rates, mixing, paras, RateParas
        print =  1
       burnin =  $burnin
     sampfreq =  $sampfreq
      nsample =  $nsample

END

	open (CTL, ">$output/mcmctree.ctl") or die "Can't write to file $output/mcmctree.ctl: $!\n";
	print CTL $ctl;
	close CTL;
}


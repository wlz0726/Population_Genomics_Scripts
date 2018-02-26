#!/usr/bin/perl
#
# 
#
use strict;
use warnings;
use Getopt::Long;
use Scalar::Util qw(looks_like_number);

#################
## Read in command line arguments

sub usageHelp{
  print "Usage: ./plink2chromopainter.pl -p=pedfile -m=mapfile -o=phasefile \n\t\t[-d=donorfile] [-r=recfile] [-g=chromosomegap] [--quiet] [--asis]\n\n";
  print "pedfile is a valid PLINK ped inputfile\n";
  print "mapfile is a valid PLINK map file\n";
  print "phasefile will be a valid chromopainter phase file (ChromoPainter's -g switch)\n";
  print "\t(i.e. a fastphase file with an additional header line)\n";
  print "donorfile is OPTIONAL and simply stores the list of individual names (NOT ChromoPainter's -f switch!)\n";
  print "recfile is OPTIONAL and will be a valid chromopainter recombination file (ChromoPainter's -r switch)\n";
  print "chromosomegap (=10e6 by default) is the gap in BP placed between different chromosomes\n";
  print "-a or --asis assume the SNPs are stored as 0/1 rather than 1/2 (default plink behaviour)\n";
  print "-q or --quiet reduces the amount of screen output\n";
  print "EXAMPLE: ./plink2chromopainter.pl myped.ped mymap.map mydata.phase donor=mydonor.donor rec=myrec.map\n";
  print "IMPORTANT: You should use the --recode12 option in plink\n";
  print "MORE HELP ON FILE FORMATS: ./plink2chromopainter.pl -h\n\n";  
}
sub usageHelpMessageDie{
  print "$_[0]\n";
  usageHelp();
  exit;
}

sub fileHelp{
      print "Detailed file format instructions:\n";
      print "PED FILE: (one individual per line)\n";
      print "\t<familyid> <indid> <paternalid> <maternalid> <sex> <phenotype> <SNPLIST>\n";
      print "\t\t<familyid>: Family ID, IGNORED.\n";
      print "\t\t<indid>: Individual ID, output to donorfile.\n";
      print "\t\t<paternalid>: Paternal ID, IGNORED.\n";
      print "\t\t<maternalid>: Maternal ID, IGNORED.\n";
      print "\t\t<sex>: Sex (1=male; 2=female; other=unknown), IGNORED.\n";
      print "\t\t<phenotype>: Phenotype, IGNORED.\n";
      print "\t\t<SNPLIST>: For L SNPs, this is 2*L entries, each of which\n";
      print "\t\t\thas the base for haplotype 1 followed by haplotype 2, \n";
      print "\t\t\tseparated by a space. e.g. If the haplotypes are\n";
      print "\t\t\t {1 2 1 1} {1 1 2 2} then <SNPLIST> will be\n";
      print "\t\t\t \"1 1 2 1 2 2 2 2\"\n";
      print "\tExample line: (note that -9 means \"missing\" in PLINK by default)\n";
      print "\t\t\t \"0 Ind1 0 0 other -9 1 1 2 1 2 2 2 2\"\n";
      print "\t\tNOTE: If haplotypes are unknown, place SNPs aribrarily and use the\n";
      print "\t\t     UNLINKED model of ChromoPainter (-u).\n";
      print "MAP FILE: one line per SNP\n";
      print "\t<chromosome> <snpno> <gendistance> <bploc>\n";
      print "\t\t<chromosome>: chromosome (1-22, X, Y or 0 if unplaced)\n";
      print "\t\t<snpno>: rs number or snp identifier\n";
      print "\t\t<gendistance> Genetic distance (morgans)\n";
      print "\t\t<bploc> Base-pair position (bp units)\n";
      print "\n\tExample line:\n";
      print "\t\"0 SNP1 0.000001 1234\"\n";
      print "\nSee PLINK website (http://pngu.mgh.harvard.edu/~purcell/plink/data.shtml) for more details.\n";   
      print "\nHelp on command line options: run again with NO arguments.\n\n";   
}

#################
## Process command line

if(@ARGV == 0) {usageHelpMessageDie("");}

my $chromosomegap = 10e6;  ## The gap we leave between SNPs detected to be on DIFFERENT CHROMOSOMES
my $quiet = 0; # quiet = 1 - verbose
my $help = ''; # detailed help
my $pedfile=""; # name of PED file to read
my $mapfile=""; # name of MAP file to read
my $outputfile=""; # name of PHASE file to write
my $donorfile=""; # name of DONOR file to write (OPTIONAL)
my $recfile=""; # name of RECOMBFILE file to write (OPTIONAL)
my $asis = 0; # amount to substract from each SNP (set to 0 by -a)
GetOptions ('quiet' => \$quiet, 
	    'help' => \$help, 
	    'asis' => \$asis,
	    'p|ped=s' => \$pedfile,
            'm|map=s' => \$mapfile,
            'o|out=s' => \$outputfile,
	    'd|donor=s' => \$donorfile,
	    'r|rec=s' => \$recfile,
	    'g|gap=s' => \$chromosomegap);
my $verbose = 1 - $quiet;
my $subtract= 1-$asis; # amount to substract from each SNP (set to 0 by -a)

if($help){fileHelp();exit;}

if ($verbose) {
  print "\tpedfile=$pedfile\n\tmapfile=$mapfile\n\tphasefile=$outputfile\n\tdonorfile=$donorfile\n\trecfile=$recfile\n\tchromosomegap=$chromosomegap bases (assuming recombination distance already handled).\n\tsubtract=$subtract\n\n";
}

if ("$pedfile" eq "") {
  usageHelpMessageDie("ERROR: Must provide a ped file via -p=<pedfile>!\n");
}elsif("$mapfile" eq "") {
  usageHelpMessageDie("ERROR: Must provide a map file via -m=<mapfile>!\n");
}elsif("$outputfile" eq "") {
  usageHelpMessageDie("ERROR: Must provide a output phase file via -o=<outputfile>!\n");
}

#################
## Check that the input files exist

unless (-e $pedfile) {
 die "ped file \"$pedfile\" Doesn't Exist!";
} 
unless (-e $mapfile) {
 die "map file \"$mapfile\" Doesn't Exist!";
}

#################
if($verbose) {print "Processing...\n";}

## Read in the map
open MAPFILE, $mapfile or die $!;

my @chroms = ();
my @snpnames = ();
my @gendist = ();
my @bploc = ();
my $num_snps = 0;
my $chromosomestart = 0;
my $prevbp=0;
# ADD ELEMENTS
while (<MAPFILE>) {
	my @tmp = split;
	$chroms[$num_snps] = $tmp[0];
	$snpnames[$num_snps] = $tmp[1];
	$gendist[$num_snps] = $tmp[2];
	if (( $num_snps > 1 )) {
	  if ($chromosomestart + $tmp[3] < $bploc[$num_snps -1] ) {
	    $chromosomestart = $bploc[$num_snps -1];
	  }
	} 
	$bploc[$num_snps] = $chromosomestart + $tmp[3];
	$prevbp = $bploc[$num_snps];
        $num_snps++;
 }
close (MAPFILE); 

print "Found $num_snps SNPs\n";

#################
## Count up the number of INDIVIDUALS in a FIRST pass of the PED file

open PEDFILE, $pedfile or die $!;
my $num_inds = 0;
while (<PEDFILE>) {
  $num_inds++;
}
close (PEDFILE); 

print "Found $num_inds Individuals\n";

## Create the recombination rate file, if needed
if ( "$recfile" ne "") {
  if ($verbose) {print "Creating recombination file $recfile\n";}
  open RECOMBFILE, ">", $recfile or die $!;
  print RECOMBFILE "start.pos recom.rate.perbp\n";
  for my $p (0 .. ($num_snps-2)) {
    print RECOMBFILE "$bploc[$p] $gendist[$p]\n";
  }
  print RECOMBFILE "$bploc[$num_snps-1] 0\n";
  close (RECOMBFILE); 
}


## Process the PED file
if ($verbose) {print "Creating phase file $outputfile\n";}
if ($verbose) {print "Printing * for each individual\n";}
################ OUTPUT HEADER
open OUTPUTFILE, ">", $outputfile or die $!;

#print OUTPUTFILE "0\n";
#print OUTPUTFILE "$num_inds\n";
my $num_haps=2*$num_inds;
print OUTPUTFILE "$num_haps\n";
print OUTPUTFILE "$num_snps\n";
print OUTPUTFILE "P ";
for my $p (0 .. ($num_snps-2)) {
  print OUTPUTFILE "$bploc[$p] ";
}
print OUTPUTFILE "$bploc[$num_snps-1]\n";
for my $p (0 .. ($num_snps-1)) {
    #print OUTPUTFILE "S";
}
#print OUTPUTFILE "\n";

################ OUTPUT INDIVIDUALS
open PEDFILE, $pedfile or die $!;
my $indon = 0;
my @indnames = ();
$| = 1;
while (<PEDFILE>) {
  my @tmp = split;
  my $tmplen = @tmp;

  $indnames[$indon] = $tmp[1];

  if ( (2 * $num_snps + 6) != $tmplen ) {
    die "Individual $indon has the wrong number of entries!\n";
  }
  ## haplotype 1
  my $toprint=0;
  for my $snpon (0 .. ($num_snps-1)) {
      $toprint= -1;
      if(looks_like_number($tmp[$snpon*2+6])){
	  $toprint = $tmp[$snpon*2+6] - $subtract;
      }else{
	  die("SNPs must be output in 0/1 format, but we received $tmp[$snpon*2+6]. Do you need to run plink with --recode12?\n");
      }
      if($toprint==0 || $toprint==1){
	  print OUTPUTFILE "$toprint";
      }else{
	  die("SNPs must be output in 0/1 format, but we received $tmp[$snpon*2+6]-$subtract. Do you need to run with/without -a?\n");
      }
  }
  print OUTPUTFILE "\n";
  ## haplotype 2
  for my $snpon (0 .. ($num_snps-1)) {
      $toprint= -1;
      if(looks_like_number($tmp[$snpon*2+7])){
	  $toprint = $tmp[$snpon*2+7] - $subtract;
      }else{
	  die("SNPs must be output in 0/1 format, but we received $tmp[$snpon*2+7]. Do you need to run plink with --recode12?\n");
      }
      if($toprint==0 || $toprint==1){
	  print OUTPUTFILE "$toprint";
      }else{
	  die("SNPs must be output in 0/1 format, but we received $tmp[$snpon*2+7]-$subtract. Do you need to run with/without -a?\n");
      }
  }
  print OUTPUTFILE "\n";
  if ($verbose) {print "*";}
  $indon++;
}
if ($verbose) {print "\n";}
close (PEDFILE); 

if ( "$donorfile" ne "") {
  if ($verbose) {print "Creating donor file $donorfile\n";}
  open DONORFILE, ">", $donorfile or die $!;

  for my $p (0 .. ($num_inds-1)) {
    print DONORFILE "$indnames[$p] \n";
  }
  close (DONORFILE); 
}

close (OUTPUTFILE); 

use strict;
use warnings;

my $gff="/home/share/data/genome/Bos_grunniens/00.Genome/YakGenome1.1/02.Annotation/01.gene/yak.gene/yak.gene.20110308.fixed.gff";
my $list=shift;

die "$0 02.p.pl.out.adjusted.10.sort \n"unless $list;
my %gff;

$list =~ /02.p.pl.out.adjusted.(\d+).sort/;
my $line=$1;

open(I,"< $gff");
while (<I>) {
    next unless(/mRNA.*ID=([\w-]+);/);
    my $id=$1;
    my @a=split(/\s+/);
    $gff{$a[0]}{$id}{start}=$a[3];
    $gff{$a[0]}{$id}{end}=$a[4];
}
close I;

my %gene;
open(IN,"/home/share/user/user104/projects/yak/angsd6.SelectiveSweeps/01.beagle/03.nsl/03.5.annot/05.gene.name/yak.gene.20110308.pep.swissprot.blast.best.01");
while(<IN>){
    chomp;
    my @a=split(/\s+/);
    $gene{$a[0]}=$_;
}
close IN;




open(I,"< $list");
open(OUT,"> $list.04genelist.20k");

my %select;
while (<I>) {
    chomp;
    next if(/^#/);
    my @a=split(/\s+/);
    my $chr=$a[0];
    my $start=$a[1];
    my $end=$a[2];
    
    if(exists $gff{$chr}){
        foreach my $id(keys %{$gff{$chr}}){
            
            if($gff{$chr}{$id}{start}-20000>$end || $gff{$chr}{$id}{end}+20000<$start){
	#print OUT "$chr\t$start\t$end\t-\t-\n";
            }else{
	if(exists $gene{$id}){
	    print OUT "$chr\t$start\t$end\t$id\t$gene{$id}\n";
	}else{
	    print OUT "$chr\t$start\t$end\t$id\t-\n";
	}
            }
            
        }
    }else{
        #print OUT "$chr\t$start\t$end\t-\t-\n";
    }
}
close I;
close OUT;



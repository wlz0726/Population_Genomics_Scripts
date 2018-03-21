#!/usr/bin/perl
use warnings;
use strict;
#tongji
if (@ARGV !=3) {
	print "perl $0 <reference><geno><chrom>\n";
	exit 0;
}
my ($reference,$in,$chrom)=@ARGV;
open FA,"$reference" or die $!;
my $chromosome=""; 
#my $seq_chr="";
my %fa=();
while(<FA>){
    if(/>(\w+)/) { $chromosome=$1;  }
    else { chomp; $fa{$chromosome}.=$_;}
}
close FA;
if($in=~/.gz/) {open IN,"zcat $in|" or die $!;}  else{open IN,$in or die $!;}

my $seq=$fa{$chrom};
my $new_seq;
my $m_pos=0;
my $len=length($seq);
while(<IN>){
chomp;
next if(/#/);
my ($chr,$pos,$ref,$altbase,$info) = (split(/\t/,$_))[0,1,3,4,9];
my @alt=split(/\,/,$altbase);
my @base=();
push @base,$ref;
push @base,@alt;
my $genotype="";
next if($info=~/\.\/\./);
if($info =~ /^(\d)[\/|\|](\d)/){
my $geno = join "",($1,$2);
next if($geno eq "00");
my ($a,$b,$c,$d)=(@base)[0,1,2,3];
$geno =~ s/0/$a/g;
$geno =~ s/1/$b/g;
$geno =~ s/2/$c/g;
$geno =~ s/3/$d/g;
$genotype=$geno;
}
#print STDERR "$genotype\n";
#====================
#next unless($chr eq $chrom);
my $short=GENO($genotype);
if($m_pos==0)     {
    $new_seq=substr($seq,0,$pos-1);
    $new_seq.=$short;$m_pos=$pos; next;
}
$new_seq.=substr($seq,$m_pos,$pos-$m_pos-1);$new_seq.=$short;
$m_pos=$pos;    
}

$new_seq.=substr($seq,$m_pos);
#===============
my $check_len=length $new_seq;
if($check_len!=$len) {die "something is wrong\t$len\t$seq\t$check_len\t$new_seq\n";}
#================
print "@"."$chrom\n";
Display_seq(\$new_seq); 
print "$new_seq"."+\n";
my $qulity="@" x $len;
Display_seq(\$qulity);
print "$qulity";
close IN;

sub GENO{
my $geno    =shift;
my ($s1,$s2)=(substr($geno,0,1),substr($geno,1,1));
my $type='hom';my $geno_s;
if($s1 eq $s2) {$type='hom';} else {$type="het";}
if($type eq "het"){
    if($geno=~/AC/||$geno=~/CA/){$geno_s="M";}
    elsif($geno=~/AG/||$geno=~/GA/){$geno_s="R";}
    elsif($geno=~/AT/||$geno=~/TA/){$geno_s="W";}
    elsif($geno=~/GC/||$geno=~/CG/){$geno_s="S";}
    elsif($geno=~/TC/||$geno=~/CT/){$geno_s="Y";}
    elsif($geno=~/GT/||$geno=~/TG/){$geno_s="K";}
    else{die "wrong$geno:$_\n";}
}
else{
    $geno_s=$s1;
}
return $geno_s;
}                                                    
sub Display_seq{
        my $seq_p=shift;
            my $num_line=(@_) ? shift : 50; ##set the number of charcters in each line
                my $disp;

                    $$seq_p =~ s/\s//g;
                        for (my $i=0; $i<length($$seq_p); $i+=$num_line) {
                                    $disp .= substr($$seq_p,$i,$num_line)."\n";
                                        }
                                            $$seq_p = ($disp) ?  $disp : "\n";
                                        }

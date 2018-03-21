#!/usr/bin/perl
use warnings;
use strict;
#tongji
if (@ARGV !=2 ) {
	print "perl $0 <tped><out>\n";
	exit 0;
}
my ($in,$out)=@ARGV;
if($in=~/.gz/) {open IN,"zcat $in|" or die $!;}  else{open IN,$in or die $!;}
open OUT,'>',$out or die $!;
my %hash=();
my ($sum,$sum_group1,$sum_group2)=(0,0,0);
while(<IN>){
    chomp;
    my @a=split;
    my ($chr,$pos)=(@a)[0,3];
    shift@a;shift@a;shift@a;shift@a;
    my $i=0;my $d=0;
    my @base=();
    while($i<8){
        my $temp=int(rand(2));
        #print "$temp\n";
        if($temp==0){$base[$d]=$a[$i];}
        elsif($temp==1){$base[$d]=$a[$i+1];}
        else{
            die"wrong rand number :$temp\n";
        }
        $i+=2;
        $d++;
    }
    my ($b1,$b2,$b3,$b4)=(@base)[0,1,2,3];
    my $str=join"",@base;
    my $bool=Check($str);
    next unless($bool);
    #===ceu yao asn yri=====
    # tau LQC indicus yak
    my ($yao,$asn,$ceu,$yri)=($b2,$b1,$b3,$b4);
    next if($yao eq $asn);
    $sum++;
    if($yao eq $ceu) {$sum_group1++;}
    elsif($yao eq $yri) {$sum_group2++;}
    else{
        die "$yao,$asn,$ceu,$yri\n";
    }
}
my ($g1_fre,$g2_fre)=($sum_group1/$sum,$sum_group2/$sum);
print OUT "$sum,$sum_group1,$sum_group2\t$g1_fre\t$g2_fre\n";
close OUT;
close IN;   

sub Check{
my $raw_str=shift;
my $str=$raw_str;
my%array=('A'=>0,'C'=>0,'T'=>0,'G'=>0,);
$array{'A'}+=$str=~s/A/a/g;
$array{'C'}+=$str=~s/C/c/g;
$array{'T'}+=$str=~s/T/t/g;
$array{'G'}+=$str=~s/G/g/g;
my@keys;
my@count;
foreach(sort{$array{$b}<=>$array{$a}}keys%array){
    push@keys,$_;
    push@count,$array{$_};
}
if($count[0]==2 && $count[1]==2) {return 1;}
else{return 0;}
}

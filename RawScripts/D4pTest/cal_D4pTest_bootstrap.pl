#!/usr/bin/perl
use warnings;
use strict;
#tongji
if (@ARGV !=2 ) {
	print "perl $0 <tped><out>\npopulation order:yao,asn,ceu,yri\n";
	exit 0;
}
my ($in,$out)=@ARGV;
if($in=~/.gz/) {open IN,"zcat $in|" or die $!;}  else{open IN,$in or die $!;}
my $split_region=2000000;
my $chrom="null";
my %split=();
my $split_i=0;
my %window=();
my $window_i=1;
while(<IN>){
    chomp;    
    my @a=split;
    my $line=$_;
    my ($chr,$pos)=(@a)[0,3];
    shift@a;shift@a;shift@a;shift@a;
    if($chrom eq "null") {$chrom=$chr;}
    if($chrom eq $chr){
        if(int($pos/2000000)>$split_i){
            #For each window of the genome, we performed 100 different sampling of alleles.
            my $temp=0;
            while($temp<100){
                my $sum_str=SUM(\%split);
                $window{$window_i}=$sum_str;
                print "$window_i\t$sum_str\n";
                $temp++;
                $window_i++;
            }
            #============================
            %split=();
            $chrom=$chr;
            $split{$line}=1;
            $split_i++;            
        }
        else{
            $chrom=$chr;
            $split{$line}=1;
        }
    }
    else{
        $chrom=$chr;
        $split{$line}=1;
        $split_i=0;
    }
}
my $temp=0;
while($temp<100){
    my $sum_str=SUM(\%split);
    $window{$window_i}=$sum_str;
    print "$window_i\t$sum_str\n";
    $temp++;
    $window_i++;
}
close IN;
print "$window_i\n";
open OUT,'>',$out or die $!;
#We generated 10,000 bootstrap replicates. For each bootstrap replicate, we
#sampled 1381 windows from the overall pool of 138,100 windows (1381 windows multiplied by
#100 different sets of alleles randomly chosen at heterozygous SNPs for a total of 138100 possible windows). 
my $bootstrap_replicates=10000;
my $i=0;
my ($total_sum_g1,$total_sum_g2)=(0,0);
my (@cal_sd_g1,@cal_sd_g2)=((),());
while($i<$bootstrap_replicates){    
    my ($sum_g1,$sum_g2)=(0,0);
    my $j=0;
    while($j<1381){
        my $rand_num=int(rand($window_i))+1;
        my ($temp1,$temp2)=(split(/\:/,$window{$rand_num}))[0,1];
        $sum_g1+=$temp1;
        $sum_g2+=$temp2;
        $j++;
    }
    my ($g1_fre,$g2_fre)=($sum_g1/($sum_g1+$sum_g2),$sum_g2/($sum_g1+$sum_g2));
    print OUT "$sum_g1\t$sum_g2\t$g1_fre\t$g2_fre\n";
    push @cal_sd_g1,$g1_fre;
    push @cal_sd_g2,$g2_fre;
    $total_sum_g1+=$sum_g1;
    $total_sum_g2+=$sum_g2;
    $i++;    
}
my ($total_ave_g1,$total_ave_g2)=($total_sum_g1/$bootstrap_replicates,$total_sum_g2/$bootstrap_replicates);
#=====95 CI=========
#The standard error was also used to construct 95% confidence intervals on the proportion of sites showing Grouping 1 and 2. These confidence intervals were calculated as , where p is the average proportion of sites showing the particular grouping and is the standard deviation of the proportion estimated across the bootstrap replicates. Confidence intervals calculated using the 2.5% and 97.5% quantiles of the distribution of bootstrapped proportions were identical to those described above. 
my $g1_info=SD(@cal_sd_g1);
my $g2_info=SD(@cal_sd_g2);
my ($g1_freq_ave,$g1_freq_sd)=(split(/\:/,$g1_info))[0,1];
my ($g2_freq_ave,$g2_freq_sd)=(split(/\:/,$g2_info))[0,1];
my ($g1_sd_up,$g1_sd_down)=($g1_freq_ave-1.96*$g1_freq_sd,$g1_freq_ave+1.96*$g1_freq_sd);
my ($g2_sd_up,$g2_sd_down)=($g2_freq_ave-1.96*$g2_freq_sd,$g2_freq_ave+1.96*$g2_freq_sd);
#my ($g1_95ci,$g2_95ci)=();
#===================
print OUT "\tGroup1\tGroup2\n";
print OUT "Observed number (Average)\t$total_ave_g1\t$total_ave_g2\n";
print OUT "Observed proportion (95% CI)\t$g1_freq_ave ($g1_sd_up to $g1_sd_down)\t$g2_freq_ave ($g2_sd_up to $g2_sd_down)\n";
close OUT;
sub SUM{
    my $hash_ref = shift;
    my %hash=%$hash_ref;
    my ($sum,$sum_group1,$sum_group2)=(0,0,0);
    foreach my $key (sort keys %hash){
    my $line=$key;
    my @a=split(/\s+/,$line);
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
    #===ceu yao asn yri===== yao1 asn2 ceu3 yri4
    #  # right order:LQC tau indicus yak
    my ($yao,$asn,$ceu,$yri)=($b2,$b1,$b3,$b4); # target H2 H3 Outgroup
    next if($yao eq $asn);
    $sum++;
    if($yao eq $ceu) {$sum_group1++;}
    elsif($yao eq $yri) {$sum_group2++;}
    else{
        die "$yao,$asn,$ceu,$yri\n";
    }
}
#if($sum==0) {return "0:0";}
#my ($g1_fre,$g2_fre)=($sum_group1/$sum,$sum_group2/$sum);
return "$sum_group1:$sum_group2";
}
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
sub SD{
    my @freq=shift;
    my $sum=0;
    my $ave=0;
    my $num=scalar@freq;
    my $i=0;
    while($i<$num){
        $sum+=$freq[$i];
        $i++;
    }
    $ave=$sum/$num;
    $sum=0;$i=0;
    while($i<$num){
        $sum+=($freq[$i]-$ave)*($freq[$i]-$ave);
        $i++;
    }
    my $sd=sqrt($sum/($num-1));
    return "$ave:$sd";
}










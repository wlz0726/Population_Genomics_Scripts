use strict;
use warnings;

####### software path
my $bedtools="/home/wanglizhong/software/bedtools/bin/bedtools";
######

my %similarity;
open(OUT,"> $0.stat"); #         $id1 $id2  $overlap1bp_percentage overlap50per_percentage overlap50per_similarity\n";
print OUT "id1 id2 overlap1bp_percentage_similarity overlap50per_percentage_similarity \n";
open(OUT2,"> $0.NumberOfOverlapBetweenPops");

my @cnv=<../01.CNV.calling/02.CNVnatorFilter.pl.1000.out/*cnv>;
for (my $i=0;$i<@cnv-1;$i++){
    for(my $j=$i+1;$j<@cnv;$j++){
	$cnv[$i] =~ /(.*\/(.+)).final.cnv/;
	my $file1="$1.final.bed";
	my $id1=$2;
	$id1 =~ /(\w)/;
	my $pop1=$1;
	
	$cnv[$j] =~ /(.*\/(.+)).final.cnv/;
	my $file2="$1.final.bed";
	my $id2=$2;
	$id2 =~ /(\w)/;
	my $pop2=$1;
	
	# overlap number
	my $overlap1bp=&overlap($file1,$file2,1E-9);
	my $overlap50per=&overlap($file1,$file2,0.5);
	
        # line number of bed1 and bed2
	my $file1_number=&line_number($file1);
	my $file2_number=&line_number($file2);
	my $average_number=($file1_number+$file2_number)/2;
	#print "$overlap1bp\t$overlap50per\t$average_number\n";
	
	# overlap percentage similarity
	my $overlap1bp_percentage=$overlap1bp/$average_number;
	my $overlap50per_percentage=$overlap50per/$average_number;
	
	print OUT "$id1\t$id2\t$overlap1bp_percentage\t$overlap50per_percentage\n";
	print OUT2 "$pop1\_$pop2\_1pb\t$overlap1bp\n$pop1\_$pop2\_50per\t$overlap50per\n";
	
    }
}
close OUT;
close OUT2;
`grep 1pb $0.NumberOfOverlapBetweenPops > $0.NumberOfOverlapBetweenPops.1pb`;
`grep 50per $0.NumberOfOverlapBetweenPops > $0.NumberOfOverlapBetweenPops.50per`;
sub overlap{
    my ($bed1,$bed2,$overlap_rate)=@_;
    my $overlap_number=`$bedtools intersect -a $bed1 -b $bed2 -f $overlap_rate|wc -l`;
    chomp $overlap_number;
    return $overlap_number;
}

sub line_number{
    my $input_file=shift;
    my $line_number=`cat $input_file|wc -l`;
    chomp $line_number;
    return $line_number;
}

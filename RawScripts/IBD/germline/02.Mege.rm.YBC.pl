#!/usr/bin/perl -w

my $length_limit=1;
die "$0 1\3\5\n"unless $length_limit;

my %pop;
open(IN,"../sample_label.rename.ids");#../new.combine.sheep.information.remove");
while(<IN>){
    chomp;
    my @a=split(/\s+/);
    #$a[4] =~ /^(\w\w\w)/;# pop
    $pop{$a[0]}=$a[1]; # ind pop
}
close IN;

my %h;
my @in=<01.VCF/*match>;
foreach my $in(@in){
    open(I,"$in");
    print "$in\n";
    while(<I>){
	chomp;
	my ($ind1,$ind2,$length)=(split(/\s+/))[1,3,10];
	my @inds=($ind1,$ind2);
	my @sort_inds=sort @inds;
	my $id=join(":",@sort_inds);
	
	my $pop1=$pop{$ind1};
	my $pop2=$pop{$ind2};
	#print "$ind1\t$ind2\t$pop1\t$pop2\n";die;
	next if($length<$length_limit);
	
	if($pop1 eq $pop2){
	    $h{$pop1}{$pop2}{$id}{count}++;
	    $h{$pop1}{$pop2}{$id}{length}+=$length;
	}else{
	    $h{$pop1}{$pop2}{$id}{count}++;
	    $h{$pop2}{$pop1}{$id}{count}++;
	    $h{$pop1}{$pop2}{$id}{length}+=$length;
	    $h{$pop2}{$pop1}{$id}{length}+=$length;
	}
    }
    close I;
}

open(OUT1,"> $0.$length_limit.Count.out");
open(OUT2,"> $0.$length_limit.Length.out");
#my @pop=sort(keys %h);

#my @pop=("African","Agarli","American","Canadensis","Europe","Iran","Kazakh","Mongolia","Morocco","South_Asian","Tibetan","Urial","Yunnan");
#my @pop=("Afr","Aga","Ame","Can","Eur","Ira","Kaz","Mon","Mor","Sou","Tib","Uri","Yun");
my @pop=("BRM","GIR","NEL","LQC","NYC","LXC","YNC","QCC","JBC","RAN","FLV","HOL","LIM","JER");

print OUT1 "Population\t",join("\t",@pop),"\n";
print OUT2 "Population\t",join("\t",@pop),"\n";
foreach my $k1 (@pop){
    print OUT1 "$k1";
    print OUT2 "$k1";
    foreach my $k2(@pop){
	my $count_total=0;
	my $length_total=0;
	my $count=0;
	my $count_ave=0;
	my $length_ave=0;
	if(exists $h{$k1}{$k2}){
	    foreach my $k3(sort keys %{$h{$k1}{$k2}}){
		
		$count_total+=$h{$k1}{$k2}{$k3}{count};
		$length_total+=$h{$k1}{$k2}{$k3}{length};
		$count++;
	    }
	    $count_ave=$count_total/$count;
	    $length_ave=$length_total/$count;
	}else{
	    $count_ave=0;
	    $length_ave=0;
	}
	print OUT1 "\t$count_ave";
	print OUT2 "\t$length_ave";
    }
    print OUT1 "\n";
    print OUT2 "\n";
}
close OUT1;
close OUT2;
`perl plot.multple.bar.pl $0.$length_limit.Count.out`;

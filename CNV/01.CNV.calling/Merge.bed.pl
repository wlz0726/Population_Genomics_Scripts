#!/usr/bin/perl -w
my $pop=shift; # B or C
my $class=shift; # del or dup
die "$0 <B> <del>\n"unless $class;
my @file=<02.CNVnatorFilter.pl.1000.out/$pop*.filter2.$class.bed>;
my %h;
my $n=1;
for(my $i=0;$i<@file;$i++){
    open(I,"$file[$i]");    
    while(<I>){
	chomp;
	my ($chr,$left,$right)=(split(/\s+/))[0,1,2];
	my $id="$left:$right";
	if($i==0){	    $h{$chr}{$n}{$id}++;	    $n++;	    next;	};
	
	my $flag=0;
	if(exists $h{$chr}){
	    foreach my $k2(sort keys %{$h{$chr}}){
		foreach my $k3(sort keys %{$h{$chr}{$k2}}){
		    $k3 =~ /(\d+):(\d+)/;
		    my $start=$1;
		    my $end=$2;
		    if($end<=$left || $start>=$right){
			next;
		    }else{
			my @sort=($left,$right,$start,$end);
			@s2=sort{$a<=>$b} @sort;
			my $overlap=$s2[2]-$s2[1];
			my $length1=$s2[2]-$s2[0];
			my $length2=$s2[3]-$s2[1];
			my $per1=$overlap/$length1; my $per2=$overlap/$length2;
			if($per1>0.5 && $per2>0.5){
			    $flag++;
			    $h{$chr}{$k2}{$id}++;
			}
		    }
		}
	    }
	}
	
	
	if($flag>0){
	}else{
	    $h{$chr}{$n}{$id}++;
	    $n++;
	}
    }
    close I;
}


open(O,"> $pop.$class.bed");
foreach my $k1(sort keys %h){
    foreach my $k2(sort keys %{$h{$k1}}){
	my $all1=0;
	my $all2=0;
	my $num=0;
	foreach my $k3(sort keys %{$h{$k1}{$k2}}){
	    my @tmp=split(/:/,$k3);
	    $all1 +=$tmp[0];
	    $all2 +=$tmp[1];
	    $num++;
	}
	my $left=int($all1/$num);
	my $right=int($all2/$num);
	print O "$k1\t$left\t$right\n";
    }
}
close O;

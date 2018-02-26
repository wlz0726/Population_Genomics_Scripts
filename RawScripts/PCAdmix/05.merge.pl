my %h;
my @in=<04.Proportions.pl.out/*>;
foreach my $in(@in){
    #$in =~ /\/(\w+).txt/;
    #my $id=$1;
    
    open(I,"$in");
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	if($a[1] =~ /^NA\// || $a[1] =~ /\/NA$/){
	    $h{$a[0]}{NA}+=$a[2];
	}else{
	    $h{$a[0]}{$a[1]}+=$a[2];
	}
    }
    close I;
    
}

open(I,"Ind.list");
my %pop;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $pop{$a[0]}=$a[1];
}
close I;


my @head=sort keys %{$h{NY440A}};
open(O,"> $0.out");
print O "#pop\tid\t",join("\t",@head),"\n";
foreach my $k1(sort keys %h){
    my $pop=$pop{$k1};
    print O "$pop\t$k1";
    foreach my $k2(@head){
	if(exists $h{$k1}{$k2}){
	    my $per=$h{$k1}{$k2};
	    print O "\t$per";
	}else{
	    print O "\t0";
	}
    }
    print O "\n";
}
close O;

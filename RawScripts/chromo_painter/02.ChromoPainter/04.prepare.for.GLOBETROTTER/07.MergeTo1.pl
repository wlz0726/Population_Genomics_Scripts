my %h;
my @f=<*out.txt>;
foreach my $f(@f){
    $f =~ /06.generate.parafile.pl.(\w+).out.txt/;
    my $pop=$1;
    open(I,"$f");
    <I>;
    my $head=<I>;
    my $per=<I>;
    close I;
    my @head=split(/\s+/,$head);
    my @per=split(/\s+/,$per);
    for(my $i=0;$i<@head;$i++){
	my $head=$head[$i];
	my $per=$per[$i];
	$h{$pop}{$head}=$per;
    }
}

my @surrogate=(BRM,GIR,LQC,NEL,JBC,JER,FLV,HOL,LIM,RAN);
print "#target\t",join("\t",@surrogate),"\n";
foreach my $k1(sort keys %h){
    my @tmp2;
    my $per=0;
    foreach my $k2(@surrogate){
	if(exists $h{$k1}{$k2}){
	    $per=$h{$k1}{$k2}
	}else{
	    $per=0;
	}
	push(@tmp2,$per);
    }
    print "$k1\t",join("\t",@tmp2),"\n"
}

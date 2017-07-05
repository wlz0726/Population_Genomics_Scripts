my $input="03.Overlap.pl.stat"; # sample1  sample2  overlap1bp_percentage overlap50per_percentage 50per_similarity

my %matrix;
open(I,"$input");
<I>;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my ($id1,$id2,$similarity)=(split(/\s+/))[0,1,3]; 
    
    if($id1 eq $id2){
	$matrix{$id1}{$id2}=$similarity;
    }else{
	$matrix{$id1}{$id2}=$similarity;
	$matrix{$id2}{$id1}=$similarity;
    }
}
close I;

my @id=sort keys %matrix;
open(OUT,"> $0.50per");
print OUT " \t",join("\t",@id),"\n";
foreach my $k1(@id){
    print OUT "$k1";
    foreach my $k2(@id){
        my $tmp2;
	if(exists $matrix{$k1}{$k2}){
	    $tmp2=$matrix{$k1}{$k2};
        }elsif($k1 eq $k2){
	    $tmp2=1;
        }else{
	    print "erro\t$k1\t$k2\n";
	    $tmp2=0;
        }
	print OUT "\t$tmp2";
    }
    print OUT "\n";
}
close OUT;

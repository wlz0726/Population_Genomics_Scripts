#`01.VCF/*match > 01.VCF.match`;
my $ibd="01.VCF.match";
my $limit=shift;
die "$0 1/2/3 MB\n"unless $limit;


my @out=("YAK");
my %out;
undef @out{@out};

my %species;
open(I,"../sample_label.rename.ids");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $species{$a[0]}=$a[1];
}
close I;

my %h;
open(I,"$ibd");
open(O,"> $0.$limit.out");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $id1=$a[0];
    my $id2=$a[2];
    my $sample1="$species{$id1}.$id1";
    my $sample2="$species{$id2}.$id2";
    #print "$sample1\t$sample2\n";die;
    my $pos1=$a[5]; 
    my $pos2=$a[6];
    my $length=$pos2-$pos1+1;
    next if($a[10])<$limit;
    #print "$species{$id1}\t$species{$id2}\n";die;
    next if(exists $out{$species{$id1}});
    next if(exists $out{$species{$id2}});
    #print "$sample1\t$sample2\n";die;
    if($sample1 eq $sample2){
	$h{$sample1}{$sample2}+= $length;
    }else{
	$h{$sample1}{$sample2}+= $length;
	$h{$sample2}{$sample1}+= $length;
    }
}
close I;

my @id=sort keys %h;
print O " \t",join("\t",@id),"\n";
foreach my $k1(@id){
    print O "$k1";
    foreach my $k2(@id){
	my $tmp;
	
	if(exists $h{$k1}{$k2} && $h{$k1}{$k2}!=0){
	    $tmp=log($h{$k1}{$k2})/log(10);
	}elsif($k1 eq $k2){
	    $tmp=10;
	}else{
	    $tmp=0;
	}
	print O "\t$tmp";
    }
    print O "\n";
}

close O;
`perl plot.pl $0.$limit.out`;

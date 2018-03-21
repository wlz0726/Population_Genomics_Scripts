my $in=shift;
$in =~ /\/(\d+).vcf.gz/;
my $chr=$1;

my %pos;
open(I,"03.print.syn.exon.pos.pl.out/$chr.exon.pos");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $pos{$a[0]}{$a[1]}++;
}
close I;



my %pop;
open(I,"list");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    $pop{$a[1]}=$a[2];
}
close I;

open(I,"zcat $in|");
my @id;
my %h;
my $num=0;
while(<I>){
    chomp;
    next if(/\#\#/);
    if(/\#/){
	@id=split(/\s+/);
	next;
    }
    my @a=split(/\s+/);
    
    next unless( exists $pos{$a[0]}{$a[1]});
    
    my $ref=$a[3];
    my $alt=$a[4];
    next if(length($a[4])>1);
    $num++;
    for(my $i=9;$i<@a;$i++){
	my $id=$id[$i];
	my $gt=$a[$i];
	if($gt =~ /0\|0/){
	    $h{$id} .=$ref;
	}elsif($gt =~ /0\|1/ || $gt =~ /1\|0/){
	    my $rand=int(rand(2));
	    if($rand==0){
		$h{$id} .=$ref;
	    }else{
		$h{$id} .=$alt;
	    }
	}elsif($gt =~ /1\|1/){
	    $h{$id} .=$alt;
	}else{
	    die "$_\n";
	}
    }
}
close I;
print "$num\n";
open(O,"> $in.exon.fa");
print O "4  $num\n";
foreach my $k(sort keys %h){
    print O "$pop{$k}  $h{$k}\n";
}
close O;

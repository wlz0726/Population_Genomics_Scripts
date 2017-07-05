my $out="$0.out";
`mkdir $out`unless -e $out;


my %hash=&id1id2("id.txt");
my %length=&id1id2("chr.length");
my @ind=("WGC022456D","WGC022457D","WGC022458D","WGC022459D","WGC022460D","WGC022461D","WGC022463D","WGC022464D","WGC022465D","WGC022466D","WGC022467D");
#my @ind=("WGC022456D","WGC022457D");
#my @ind=("WGC022456","WGC022457","WGC022458","WGC022459","WGC022460","WGC022461","WGC022463","WGC022464","WGC022465","WGC022466","WGC022467");
foreach my $ind(@ind) {
    my $ind2=$ind;
    $ind2 =~ s/D$//;
    my $name=$hash{$ind2};
    open(O,"> $out/$name.txt");
    my @f=<../01.cnv.V4.seperate.pl.1000.out/CNV/$ind/*l3>;
    foreach my $f(@f){
	$f =~ /\/CNV\/([^\/]+)D\/([^\/]+)\.([^\/]+)\.root\.l3/;
	my $id1=$1;
	my $id2=$hash{$1};
	my $length=$length{$3};
	my $chr=$3;
	#print "$1\t$id\t$length\t$chr\t";
	open(I,$f);
	<I>;<I>;<I>;<I>;<I>;
	my $line=<I>;
	$line =~ /Average RD per bin \(1-22\) is ([\d\.e\-]*) \+\- ([\d\.e\-]*) \(/;
	my $dp1=$1;
	my $dp2=$2;
	my $rat=$dp1/($dp2+0.0001);
	#print "$id2\t$chr\t$length\t$dp1\t$dp2\t$rat\n";
	print O "$id2\t$chr\t$length\t$dp1\t$dp2\t$rat\n";
    }
    close O;
}



# sub
sub id1id2{
    my $input=shift;
    my %h=();
    open(I,"$input");
    while(<I>){
        chomp;
        #next if(/^\#/);
        my ($id1,$id2)=(split(/\s+/))[0,1];
        $h{$id1}=$id2;
    }
    close I;
    return %h;
}


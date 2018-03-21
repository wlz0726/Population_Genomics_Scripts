my $samplelist="../00.Data/new.combine.sheep.information.remove"; # samplelist with all populations; only need two cols: sample_id  population

my @pop=(Iran,Kazakh,Mongolia,Tibetan,Yunnan,Europe,African,American);
my %h2;
undef @h2{@pop};


open(I,"$samplelist"); 
my %h;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    if(exists $h2{$a[4]}){
	$h{$a[4]}{$a[0]}++;
    }
}
close I;

foreach my $k1(keys %h){
    my $num=keys %{$h{$k1}};
    #next if $num<5;
    
    my $outdir="Pop_$k1";
    `mkdir $outdir` unless (-e "Pop_$k1");
    open(O,"> Pop_$k1/$k1.txt");
    foreach my $k2(sort keys %{$h{$k1}}){
	print O "$k2\n";
    }
    close O;
}

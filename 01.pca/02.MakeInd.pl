my $ped=shift;
my $out=$ped."ind";
my $count=0;
open(O,'>'."$out");
open(F,$ped);
while(<F>){
    chomp;
    if(/^(\S+)\s(\S+)/){
        my $species=$1;
	my $ind=$2;
        $count++;
        
        print O "$count\t$ind\t0\t0\t0\t$species\n";
    }
}
close(F);
close(O); 

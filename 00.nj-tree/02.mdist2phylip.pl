my ($mdist,$ped,$out)=@ARGV;
die "$0 mdist tfam outprefix.phylip\n"unless $out;

my @species=&readSpecies($ped);

open(O,'>',$out);
print O "\t",scalar(@species),"\n";

my $i=0;
open(F,$mdist);
while(<F>){
    chomp;
    my $len=length($species[$i]);
    my $x=10-$len;
    my $a=" " x $x;
    print O "$species[$i]","$a\t$_\n";
    $i++;
}
close(F);

close(O);


sub readSpecies{
    my $file=shift;
    my @a;
    open(F,$file);
    while(<F>){
	chomp;
    if(/^(\S+)/){
      push @a,$1;
    }

    }
    close(F);
  #  print "\t",scalar(@a),"\n";
    return @a;
}

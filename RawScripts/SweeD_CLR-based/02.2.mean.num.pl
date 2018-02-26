my $in=shift;


my $all;
my $num;

open(IN,"$in");
while(<IN>){
    chomp;
    my @a=split(/\s+/);
    $all+=$a[4];
    $num++;
}
close IN;
my $mean=$all/$num;
open(OUT,"> $in.meannum");
print OUT "$in\t$mean\t$all\t$num\n";
close OUT;

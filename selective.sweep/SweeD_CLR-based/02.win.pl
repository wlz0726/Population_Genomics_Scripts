my $in=shift;
my $window="50000";
my $step="50000";

my %length;
open(IN,"/home/share/user/user104/projects/yak/ref/yak0803_v2.sca.break.fa.filter2K.fa.Length.stat.list");
while(<IN>){
    chomp;
    my @a=split(/\s+/);
    $length{$a[0]}=$a[1];
}
close IN;

my %h;
open(IN,"$in");
while(<IN>){
    chomp;
    next if(/CHR/);
    my @a=split(/\s+/);
    #$a[2] =~ /^(.*):(\d+)$/;
    my $chr=$a[0];
    my $pos=$a[1];
    my $value=$a[2];
    next if ($length{$chr} < $window);
    
    for(my $i=0;(($i*$step)+$window)<=$length{$chr};$i++){
        $start=($i*$step)+1;
        $end=($i*$step)+$window;
        if($pos >= $start && $pos <= $end){
            if(exists $h{$chr}{$start}){
	if($value>$h{$chr}{$start}){
	    $h{$chr}{$start}=$value;
	    $h{$chr}{$start}{pos}=$pos;
	}
            }else{
	$h{$chr}{$start}=$value;
	$h{$chr}{$start}{pos}=$pos;
            }
            $h{$chr}{$start}{num}++;
        }
    }
}
close IN;

my $line=1;
open(OUT,"> $in.w$window.s$step.out");
foreach my $k1(sort keys %h){
    foreach my $k2(sort{$a<=>$b} keys %{$h{$k1}}){
        print OUT "$line\t$k1\t$k2\t$h{$k1}{$k2}\t$h{$k1}{$k2}{num}\t$h{$k1}{$k2}{pos}\n";
        $line++;
    }
}

close OUT;

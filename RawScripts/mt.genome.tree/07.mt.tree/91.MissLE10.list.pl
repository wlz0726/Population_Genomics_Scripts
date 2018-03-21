use strict;
use warnings;
use Bio::SeqIO;

open (O,">$0.type.list");
my %type;
my $line="D-loop:892      codon.1:3746    codon.2:3744    codon.3:3743    rRNA:2528       tRNA:1505";
my @line=split(/\:|\s+/,$line);
my $start=1;
print O "OLD\t";
for (my $i=1;$i<@line;$i=$i+2){
    my $type=$line[$i-1];
    $type{$type}{start}=$start;
    my $end=$start+$line[$i]-1;
    $type{$type}{end}=$end;
    print O "$type:$start-$end\t";
    $start=$start+$line[$i];
}
print O "\n";
my %new;
open (F,"6.stastic.pl.coordmisfenbu")||die"$!";
open (O1,">$0.seq.list");
while (<F>) {
    chomp;
    next if /^coord/;
    my @a=split(/\s+/,$_);
    next if ($a[3]>0.1 || $a[6]>0.1);
    my $check=0;
    for my $k (sort keys %type){
        if ($type{$k}{start}<=$a[0] && $type{$k}{end}>=$a[0]){
            print O1 "$a[0]\t$k\n";
            $new{$k}++;
            $check++;
        }
    }
    die "$_\n" if $check != 1;
}
close O1;
my $newstart=1;
print O "NEW\t";
for my $k1 (sort{$type{$a}{start} <=> $type{$b}{start}} keys %type){
    #print "$k1\n";
    my $len=$new{$k1};
    my $end=$newstart+$len-1;
    #print "$k1\t$newstart\t$end=$newstart+$len-1\n";
    print O "$k1:$newstart-$end\t";
    $newstart=$newstart+$len;
}
print O "\n";
close O;

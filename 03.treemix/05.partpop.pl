my $in="treemix.input.gz";
my $list=shift;
die "$0 pop.list\n"unless $list; # two cols, same as poporder file with one col (population name per line) or two cols (popname color)

#`zcat $in|head -1 |> $in.head`;

my %head;
open(I,"zcat $in|");
my $line=<I>;
chomp $line;
my @tmp=split(/\s+/,$line);
for(my $i=0;$i<@tmp;$i++){
    $j=$i+1;
    my $id=$tmp[$i];
    $head{$id}=$j;
    print "$id\t$j\n";
}
close I;

my $out="$list.treemix";
`mkdir $out`unless -e $out;

open(O,"> $list.sh");
my %h;
open(I,"$list");
my @cols;
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $num=$head{$a[0]};
    my $num_id="\$"."$num";
    push(@cols,$num_id);
}
close I;

print O "zcat $in|awk '{print ",join(",",@cols),"}'|gzip -c > $out/treemix.input.gz\n";
close O;

`cp $list $out/poporder`;
`cp plot.R $out`;
`cp treemix_fraction.pl $out`;
`cp *sh $out`;

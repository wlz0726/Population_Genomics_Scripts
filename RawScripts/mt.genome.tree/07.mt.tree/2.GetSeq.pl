use strict;
use warnings;

`mkdir seq`;

my %list;
open (F,"1.diftype.pl.list")||die"$!";
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    $list{$a[0]}=$a[1];
    
}
close F;
my %seq;
open (F,"download.fa.reorderDloop.aln.fa.table")||die"$!"; # table file
my @id;
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    if (/reference/){
        @id=@a;
        next;
    }
    #print "next if ! exists \$list{$a[0]}\n";
    next if ! exists $list{$a[0]};
    for (my $i=1;$i<@a;$i++){
        my $id=$id[$i];
        #$id=~s/^\S+\|\S+\|\S+\|(\S+)\|/$1/;
        my $type=$list{$a[0]};
        $seq{$type}{$id}{$a[0]}=$a[$i];
        #print "$seq{$type}{$id}{$a[0]}=$a[$i]\n";
    }
}
close F;


my %flt;
open (F,"remove.bad.list")||die"$!"; # remove bed individuals; each individual ID per line
while (<F>) {
    chomp;
    $flt{$_}++;
}
close F;


for my $seqtype (sort keys %seq){
    print "$seqtype\t",scalar(keys %{$seq{$seqtype}}),"\t";
    open (O,">seq/2.$seqtype.2.fas");
    for my $species (sort keys %{$seq{$seqtype}}){
	next if(exists $flt{$species});
        print O ">$species\n";
        print scalar(keys %{$seq{$seqtype}{$species}}),"\n" if $species eq 'JQ692071.1';
        for my $pos (sort{$a<=>$b} keys %{$seq{$seqtype}{$species}}){
            print O "$seq{$seqtype}{$species}{$pos}";
        }
        print O "\n";
    }
    close O;
}

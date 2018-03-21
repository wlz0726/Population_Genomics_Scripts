use strict;
use warnings;
use FileHandle;
use Bio::SeqIO;

my %name;
my $file="/home/share/user/user102/project/Things/wanglizhong/mt-tree/001.MrBayes/other/downloads_plus_ref.fasta.list";
open (F,"$file")||die"$!";
while (<F>) {
    chomp;
    /gi\|\d+\|\w+\|(\S+)\|\s+(\S+\s+\S+)\s+/ or die "$_\n";
    my $id=$1;
    my $name=$2;
    $name=~s/\s+/_/g;
    #next if $name !~ /Bos_grunniens/;
    if ($_=~/^>chMT/){
        $name{chMT}="chMT-$id-$name";
    }else{
        $name{$id}="$id-$name";
    }
}
close F;

my %list;
open(F,"91.MissLE10.list.pl.seq.list")||die"$!";
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    $list{$a[1]}{$a[0]}++;
}
close F;

open (O1,">92.MissLE10.seq.fas");
my $fa=Bio::SeqIO->new(-file=>"5.merge.fas",-format=>"fasta");
while (my $seq=$fa->next_seq) {
    my $id=$seq->id;
    my $seq=$seq->seq;
    if (exists $name{$id}){
        $id=$name{$id};
    }
    my @seq=split(//,$seq);
    print O1 ">$id\n";
    for my $k1 ("D-loop","codon.1","codon.2","codon.3","rRNA","tRNA"){
        open (O,">>seqMiss10/$k1.fas");
        print O ">$id\n";
        for my $k2 (sort{$a<=>$b} keys %{$list{$k1}}){
            print O "$seq[$k2]";
            print O1 "$seq[$k2]";
        }
        print O "\n";
        close O;
    }
    print O1 "\n";
}
close O1;

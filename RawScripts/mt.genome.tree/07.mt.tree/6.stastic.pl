use strict;
use warnings;
use Bio::SeqIO;

#my %name;
#my $file="/home/share/user/user102/project/Things/wanglizhong/mt-tree/001.MrBayes/other/downloads_plus_ref.fasta.list";
#open (F,"$file")||die"$!";
#while (<F>) {
#    chomp;
#    /gi\|\d+\|\w+\|(\S+)\|\s+(\S+\s+\S+)\s+/ or die "$_\n";
#    my $id=$1;
#    my $name=$2;
#    $name=~s/\s+/_/g;
#    #next if $name !~ /Bos_grunniens/;
#    $name{$id}=$name;
#}
#close F;
my %other;
my %yak;
my %miss;
my $fa=Bio::SeqIO->new(-file=>"5.mergeseq.merge.fas",-format=>"fasta");
while (my $seq=$fa->next_seq) {
    my $id=$seq->id;
    my $seq=$seq->seq;
    if ($id =~ /.*\_.*\_.*/){
        #next if $name{$id} !~ /Bos_grunniens/;
        #$id="$id"."_$name{$id}";
        $other{$id}++;
    }else{
        #next  if $id=~/^(BBU|BBi|BBo|BTA)/;
        $yak{$id}++;
    }
    my @seq=split(//,$seq);
    for (my $i=0;$i<@seq;$i++){
        if ($seq[$i] eq '-'){
            $miss{geti}{$id}++;
            if ($id=~/_.*_/){
		$miss{coord}{$i+1}{other}++;
            }else{
		$miss{coord}{$i+1}{yak}++;
            }
        }
    }
}

my $other=scalar(keys %other);
my $yak=scalar(keys %yak);
my $all="16338";
print "$other\n$yak\n";
open (O1,">6.stastic.pl.getimisfenbu");
print O1 "species\tmiss\tpercent\n";
for my $k (sort keys %{$miss{geti}}){
    my $miss=$miss{geti}{$k};
    my $per=$miss/$all;
    print O1 "$k\t$miss\t$per\n";
}
close O1;
open (O1,">6.stastic.pl.coordmisfenbu");
print O1 "coord\tothermiss\totherall\tper\tyakmiss\tyakall\tper\n";
for (my $k1=1;$k1<=$all;$k1++){
    my $miss1=0;
    my $miss2=0;
    $miss1=$miss{coord}{$k1}{other} if exists $miss{coord}{$k1}{other};
    $miss2=$miss{coord}{$k1}{yak} if exists $miss{coord}{$k1}{yak};
    my $per1=$miss1/$other;
    my $per2=$miss2/$yak;
    print O1 "$k1\t$miss1\t$other\t$per1\t$miss2\t$yak\t$per2\n";
}
close O1;

use strict;
use warnings;

my %list;
open (F,"7.onlyYakMissLE10.pl.list")||die"$!";
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    $list{$a[0]}=$a[1];
}
close F;
my %name=&readNAME();
my %seq;
open (F,"/home/share/user/user113/WLZ_mitochondria/vcflike_head.txt")||die"$!";
my @id;
while (<F>) {
    chomp;
    my @a=split(/\s+/,$_);
    if (/^\s+chMT/){
        @id=@a;
        next;
    }
    next if ! exists $list{$a[0]};
    for (my $i=1;$i<@a;$i++){
        my $id=$id[$i];
        if ($id eq 'chMT'){
            $id="JQ692071.1_Bos_grunniens";
        }else{
            $id=~s/^\S+\|\S+\|\S+\|(\S+)\|/$1/ or die"$id[$i]\n";
            $id=$name{$id};
            $id=~s/\s+/_/g or die "$id[$i]\n";
            next if $id !~ /Bos_grunniens/;
        }
        my $type=$list{$a[0]};
        $seq{$type}{$id}{$a[0]}=$a[$i];
        #print "$seq{$type}{$id}{$a[0]}=$a[$i]\n";
    }
}
close F;

my %badlist=&readBADELIST();
open (F,"../001.MrBayes/yak.raw.vcf")||die"$!";
while (<F>) {
    chomp;
    next if /^##/;
    my @a=split(/\t/,$_);
    if (/^#/){
        $_=~s/bowtie2\///g;
        $_=~s/\.sort.bam//g;
        @id=split(/\t/,$_);
        next;
    }
    next if (length($a[3])>1 || length($a[4])>1);
    next if ! exists $list{$a[1]};
    next if ($a[7]=~/INDEL/);
    my $type=$list{$a[1]};
    for (my $i=9;$i<@a;$i++){
        my $id=$id[$i];
        next if exists $badlist{$id};
        next if $id=~/BBU|BBi|BBo|BTA/i;
        my ($word,$dp);
        my @b=split(/\:/,$a[$i]);
        if ($a[$i] =~ /^\d\/\d\:/){
            my $dp=$b[2];
            #print "$a[0]\t$a[1]\t$dp\n$a[$i]\n",join("\n",@b),"\n";exit;
            if ($dp < 3){
	$word='-';
            }else{
	if($a[$i]=~/^0\/0/){
	    $word=$a[3];
	}elsif($a[$i]=~/^(1\/1|0\/1)/){
	    $word=$a[4];
	}else{
	    die "wrong $a[0]\t$a[1]\t$a[$i]\n";
	}
            }
        }else{
            my $dp=$b[1];
            if ($dp<3){
	$word='-';
            }else{
	$word=$a[3];
            }
        }
        $seq{$type}{$id}{$a[1]}=$word;
    }
}
close F;

for my $seqtype (sort keys %seq){
    print "$seqtype\t",scalar(keys %{$seq{$seqtype}}),"\t";
    `mkdir seqMiss10` if (! -e "seqMiss10");
    open (O,">seqMiss10/2.$seqtype.fas")||die"$!";
    for my $species (sort keys %{$seq{$seqtype}}){
        print O ">$species\n";
        print scalar(keys %{$seq{$seqtype}{$species}})," ";
        for my $pos (sort{$a<=>$b} keys %{$seq{$seqtype}{$species}}){
            print O "$seq{$seqtype}{$species}{$pos}";
        }
        print O "\n";
    }
    close O;
    print "\n";
}

sub readNAME{
    my $infile="/home/share/user/user102/project/Things/wanglizhong/mt-tree/001.MrBayes/other/downloads_plus_ref.fasta.list";
    my %r;
    open (F,"$infile")||die"$!";
    while (<F>) {
        chomp;
        $_=~/gi\|\d+\|\w+\|(\S+)\|\s+(\w+\s+\w+)/ or die "$_\n";
        $r{$1}="$1"."_$2";
    }
    close F;
    return %r;
}
sub readBADELIST{
    my %r;
    open (F,"/home/share/user/user102/project/Things/wanglizhong/mt-tree/remove.bad.list")||die"$!";
    while (<F>) {
        chomp;
        $r{$_}++;
    }
    close F;
    return %r;
}

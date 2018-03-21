use strict;
use warnings;

my %h;
open (F,"/home/wanglizhong/project/01.cattle.CATwiwR/18.mt.genome/01.v2.AllReadsToFasta/MtRef/Bos.taurus.Ref.AF492351.1.fa.gb")||die"$!"; # genebank file of MT ref genome; annotation
my $line=0;
while (<F>) {
    chomp;
    if (/^\s+(D-loop|rRNA|tRNA|CDS)\D+(\d+)\.\.(\d+)/){
        my $type=$1;
        my $start=$2;
        my $end=$3;
        $line++;
        my $j=0;
        for (my $i=$start;$i<=$end;$i++){
            my $newtype;
            if ($type eq 'CDS'){
		next if ($i<$start+3 || $i>$end-3); # mt genome; with no intro; remove Start-codom and End-condom
		$j++;
		$newtype="codon.$j";
            }else{
		$newtype=$type;
            }
            $h{$i}{$line}=$newtype;
            $j=0 if $j == 3;
        }
    }
}
for my $k (sort keys %h){
    my @k2=keys %{$h{$k}};
    delete($h{$k}) if scalar(@k2)>1;
}

my %flt;
open (F,"remove.bad.list")||die"$!"; # remove bed individuals; each individual ID per line
while (<F>) {
    chomp;
    $flt{$_}++;
}
close F;

my %seq;
my @id;
open (F,"../06.rawSNPcalling.pl.out/mt.raw.vcf")||die"$!"; # mt snp calling file with all site 
while (<F>) {
    chomp;
    next if /^\#\#/;
    my @a=split(/\t/,$_);
    if (/^\#/){
        $_=~s/01.AllReadsBam2fq2bam.pl.out\///g;
        $_=~s/\.sort.bam//g;
        @id=split(/\t/,$_);
        next;
    }
    next if (length($a[3])>1 || length($a[4])>1);# remove indel
    next if ! exists $h{$a[1]};
    next if ($a[7]=~/INDEL/);
    
    for my $key2 (sort keys %{$h{$a[1]}}){
        my $type=$h{$a[1]}{$key2};
        for (my $i=9;$i<@a;$i++){
            my $id=$id[$i];
            next if exists $flt{$id};
            next if ! exists $h{$a[1]};
            #next if $id=~/bbu|bbo/i;
            my ($word,$dp);
            my @b=split(/\:/,$a[$i]);
            if ($a[$i] =~ /^\d\/\d\:/){
		my $dp=$b[2]; # GT:PL:DP:SP:GQ
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
            #print "\$seq{$type}{$id}{$a[1]}=$word\n";
        }
    }
}
close F;

my $dir='seq';
open (O1,">$0.list");
open(LOG,"> $0.log");
for my $seqtype (sort keys %seq){
    `mkdir $dir`unless -e $dir;
    open (O,">seq/2.$seqtype.1.fas");
    my $time=0;
    for my $species (sort keys %{$seq{$seqtype}}){
        print O ">$species\n";
        $time++;
        print LOG "$seqtype\t",scalar(keys %{$seq{$seqtype}{$species}}),"\n" if $time==1;
        for my $pos (sort{$a<=>$b} keys %{$seq{$seqtype}{$species}}){
            print O1 "$pos\t$seqtype\n" if $time==1;
            print O "$seq{$seqtype}{$species}{$pos}";
        }
        print O "\n";
    }
    close O;
}
close O1;
close LOG;

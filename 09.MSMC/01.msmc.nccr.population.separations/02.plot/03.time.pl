my @f=@ARGV;
#die "$0 outprefix M51-CDX.nccr.8haps.final.txt.0.txt M51-CDX.nccr.8haps.final.txt.0.txt ...\n"unless @ARGV;
die " for i in *.final.txt;do perl 01.plot_rate.pl \$i \$i&&rm \$i.epss.pdf;done
$0 outprefix M51-CDX.nccr.8haps.final.txt.0.txt M51-CDX.nccr.8haps.final.txt.0.txt ...\n"unless @ARGV;


my $out=shift(@f);

my %h;
open(O,"> $0.$out.log");
for my $f(@f){
    #$f =~/^([_-a-zA-Z\d]+)/;
    $f =~ /^(.*).final.txt/;
    my $id=$1;
    $id =~ s/_/-/;
    open(I,"$f");
    while(<I>){
	chomp;
	my @a=split(/\s+/);
	if($a[1]>0.25){
	    my $int=int($a[0]/1000)*1000;
            print O "$id\t0.25\t$int\t$a[1]\t$a[0]\n";
	    $h{$id}{0.25}=$a[0];
            last;
        }
    }
    close I;
    
    open(I,"$f");
    while(<I>){
        chomp;
        my @a=split(/\s+/);
        if($a[1]>0.5){
	    my $int=int($a[0]/1000)*1000;
	    print O "$id\t0.5\t$int\t$a[1]\t$a[0]\n";
	    $h{$id}{0.5}=$a[0];
	    last;
        }
    }
    close I;

    open(I,"$f");
    while(<I>){
        chomp;
        my @a=split(/\s+/);
        if($a[1]>0.75){
	    my $int=int($a[0]/1000)*1000;
	    print O "$id\t0.75\t$int\t$a[1]\t$a[0]\n";
	    $h{$id}{0.75}=$a[0];
	    last;
        }
    }
    close I;
    
    
}
close O;

open(O2,"> $0.$out.txt");
print O2 "#popA-popB\t0.25\t0.5\t0.75\n";
foreach my $k1(sort{$h{$a}{0.5}<=>$h{$b}{0.5}} keys %h){
    
    print O2 "$k1\t$h{$k1}{0.25}\t$h{$k1}{0.5}\t$h{$k1}{0.75}\n";
}
close O2;

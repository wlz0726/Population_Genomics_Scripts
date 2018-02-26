my ($vcf,$pos,$outdir)=@ARGV;
$vcf =~ /00.phased.vcf\/Chr(.*).phased.vcf/;
my $chr=$1;

my %h;
open(I,"zcat $pos|");
while(<I>){
    chomp;
    my @a=split(/\s+/);
    my $pos=$a[1];
    my $cm=$a[3];
    #$h{$pos}++;
    $h{$pos}=$cm;
}
close I;

open(I,"zcat $vcf|");
open(O1,"> $outdir/$chr.recomrate");
print O1 "start.pos recom.rate.perbp\n";
open(O2,"|gzip -c > $outdir/$chr.vcf.gz ");
while(<I>){
    chomp;
    if(/^\#/){
	print O2 "$_\n";
	next;
    }
    s/^Chr([^\s]+)/$1/;
    my @a=split(/\s+/);
    if(exists $h{$a[1]}){
	
	print O1 "$a[1]\t$h{$a[1]}\n";
	print O2 "$_\n";
    }
}
close I;
close O1;
close O2;

#my $bam=shift;

#open(I,"/home/wanglizhong/bin/samtools view ");
while(<>){
    chomp;
    if(/^\@/){
	print "$_\n";
	next;
    }
    my @a=split(/\s+/);
    $a[16] =~ /NM:i:(\d+)/;
    next if($1>10); # NM tag; filter mismatch > 10% for 100bp read
    print "$_\n";
}

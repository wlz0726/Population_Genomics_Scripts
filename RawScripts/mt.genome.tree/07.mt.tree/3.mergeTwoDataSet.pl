use strict;
use warnings;


`mkdir mergeseq`;
my @type=("codon.1","codon.2","codon.3","D-loop","tRNA","rRNA");
for my $type (@type){
    my $seq1="seq/2.$type.1.fas.2";
    my $seq2="seq/2.$type.2.fas.2";
    die "no $seq1\n" if (! -e "$seq1");
    die "no $seq2\n" if (! -e "$seq2");
    print "cat $seq1 $seq2 > mergeseq/$type.fas\n";
}

use strict;
use warnings;
use Bio::SeqIO;

my ($in,$ref)=@ARGV;
die "perl $0 input_alignment_out(fasta format) ref_id\n" if (! $ref);
my %site;

my $fa=Bio::SeqIO->new(-format=>"fasta",-file=>"$in");
while (my $seq=$fa->next_seq) {
    my $id=$seq->id;
    my $seq=$seq->seq;
    my @seq=split(//,$seq);
    my $real=0;
    for (my $i=0;$i<@seq;$i++){
        $real++ if $seq[$i] ne '-';
        $site{$id}{$i}{seq}=$seq[$i];
        $site{$id}{$i}{real}=$real;
    }
}

my %out;
my @id=sort keys %site;
my @coord=sort{$a<=>$b} keys %{$site{$ref}};
for my $coord (@coord){
    next if ($site{$ref}{$coord}{seq} eq '-');
    my $refcoord=$site{$ref}{$coord}{real};
    for my $id (@id){
        #next if $id eq $ref;
        my $duiying;
        if ($site{$id}{$coord}{seq} eq '-'){
            $duiying='-';
        }else{
            $duiying=$site{$id}{$coord}{real};
        }
        $out{$refcoord}{$id}=$site{$id}{$coord}{seq};
    }
}

print "$ref\t";
for my $id(@id){
    #next if $id eq $ref;
    print "$id\t";
}
print "\n";
for my $k1 (sort{$a<=>$b} keys %out){
    print "$k1\t";
    for my $k2 (@id){
        #next if $k2 eq $ref;
        print "$out{$k1}{$k2}\t";
    }
    print "\n";
}

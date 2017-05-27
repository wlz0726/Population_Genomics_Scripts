my $list1=shift;
my $list2=shift;

die "$0 list1 list2\n"unless $list2;

#$list1 =~ /^\d+\.(.*\.v\d).03genelist/;
my $id1=$list1;
#$list2 =~ /^\d+\.(.*\.v\d).03genelist/;
my $id2=$list2;
print "$id1\t$id2\n";

my %h;
open(IN,"$list1");
while(<IN>){
    chomp;
    $h{$_}++;
}
close IN;

open(IN,"$list2");
while(<IN>){
    chomp;
    $h{$_}++;
}
close IN;

open(IN,"$list1");
open(OUT1,"> $id1.nonOverlap.$id2");
open(OV,"> $0.$id1.$id2");
while(<IN>){
    chomp;
    if($h{$_}==1){
        print OUT1 "$_\n";
    }elsif($h{$_}==2){
        print OV "$_\n";
    }else{
        print "erro!!!!!\n";
    }
    
}
close IN;
close OUT1;
close OV;

open(IN,"$list2");
open(OUT2,"> $id2.nonOverlap.$id1");
#open(OV,"> $0.$id2.$id1");
while(<IN>){
    chomp;
    if($h{$_}==1){
        print OUT2 "$_\n";
    }elsif($h{$_}==2){
        print OV "$_\n";
    }else{
        print "$_\terro!!!!!\n";
    }
}
close IN;
close OUT2;
#close OV;

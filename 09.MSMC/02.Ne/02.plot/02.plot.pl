my $mu='7.5e-9';
my $g='3';

open(O,"> $0.sh");
print O "cat ";

my @in=@ARGV;
die "$0 BRM.txt FLV.txt ...\n"unless @in;

print O join(" ",@in),"> all;\n";
print O "perl plot_Ne.pl -M \"";
my @name;
foreach my $f(@in){
    $f =~ /(\w+).final\.txt/;
    push(@name,$1);
}
print O join(",",@name),"\" -u $mu -g $g -x 1000 -X 100000 -w 4 -R $0 all\nrm all\n";

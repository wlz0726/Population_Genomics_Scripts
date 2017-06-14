my $mu='9.796e-9';
my $g='5';

open(O,"> $0.sh");
print O "cat ";

my @in=@ARGV;
die "$0 BRM.txt FLV.txt ...\n"unless @in;

print O join(" ",@in),"> all;\n";
print O "perl plot_Ne_MAR.pl -M \"";
my @name;
foreach my $f(@in){
    $f =~ /(\w+)\.txt/;
    push(@name,$1);
}
print O join(",",@name),"\" -u $mu -g $g -x 1000 -w 6 -R $0 all\n";

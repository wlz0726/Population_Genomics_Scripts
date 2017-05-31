my ($phylip,$outfile,$outtree)=@ARGV;

open(O,'>',"$phylip.config");
print O "$phylip\nY\n";

close(O);

#print "neighbor 0<$phylip.config\n";

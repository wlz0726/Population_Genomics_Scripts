my @target=(LXC, NYC, QCC, YBC, YNC);
my @all=(BRM, GIR, LQC, NEL, LXC, NYC, QCC, YBC, YNC, JBC, JER, FLV, HOL, LIM, RAN);
my %h;
foreach my $all(@all){
    $h{$all}++;
}
open(O2,"> $0.sh");
for(my $i=0;$i<@target;$i++){
    my $pop=$target[$i];
    open(O1,"> $0.$pop.paramfile");
    my @tmp;
    foreach my $all(@all){
	next if ($all =~ /$pop/);
	push (@tmp,$all);
    }
    my $copyvector_popnames=join(" ",@all);
    my $surrogate_popnames=join(" ",@tmp);
    my $target_popname=$pop;
    print O1 "prop.ind: 1
bootstrap.date.ind: 0
null.ind: 0
input.file.ids: sample_label.ids
input.file.copyvectors: 03.Second.Run.pl.out.pick.combine.chunklengths.out
save.file.main: $0.$pop.out
save.file.bootstraps: $0.$pop.btout
copyvector.popnames: $copyvector_popnames
surrogate.popnames: $surrogate_popnames
target.popname: $target_popname
num.mixing.iterations: 0
props.cutoff: 0.001
bootstrap.num: 20
num.admixdates.bootstrap: 1
num.surrogatepops.perplot: 3
curve.range: 1 50
bin.width: 0.1
xlim.plot: 0 50
prop.continue.ind: 0
haploid.ind: 0
";

print O2 "R < GLOBETROTTER.R $0.$pop.paramfile 03.Second.Run.pl.out.pick.samplesfile.txt 03.Second.Run.pl.out.pick.recomfile.txt --no-save > $0.$pop.log;\n";
}
close O1;
close O2;

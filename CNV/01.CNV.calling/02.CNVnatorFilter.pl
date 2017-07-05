my $dir="01.cnv.V4.seperate.pl.1000.out";
die "01.cnv.V4.seperate.pl.1000.out\n"unless $dir;

# change this before runing 
my $ngap="/home/wanglizhong/project/02.blind_mole_rat.RATxdeR/ref/004.N.region/allcontig.agp.v2.bed";
my $repeat_mask="/home/wanglizhong/project/02.blind_mole_rat.RATxdeR/ref/003.repeat.region/RepeatMasker.bed";
my $gene="/home/wanglizhong/project/02.blind_mole_rat.RATxdeR/ref/002.gff.region/ref_S.galili_v1.0_top_level.V2.gff3.gz.gene.bed";
my $bedtools="/home/wanglizhong/bin/bedtools";
# blew line should adapt to your own one depend on your population infomation: 
# line 48 and 49: print O5 "cat $out/B*.final.bed | sort -k1,1 -k2,2n > $out/B.merge.sort; cat $out/C*.final.bed|sort -k1,1 -k2,2n > $out/C.merge.sort\n";
#================================= end

# id.txt is need
$dir =~ /.seperate.pl.(\d+).out/;
my $id=$1;
my $out="$0.$id.out";
`mkdir $out`unless(-e $out);


open(O,"> $0.$id.1.sh");
open(O2,"> $0.$id.2.sh");
open(O3,"> $0.$id.3.sh");
open(O4,"> $0.$id.4.annot.sh");
open(O5,"> $0.5.sh");
my %hash=&id1id2("id.txt");
my @f=<$dir/CNV/*cnv>;
foreach my $f(@f){
    $f =~ /01.cnv.V4.seperate.pl.(\d+).out\/CNV\/(\w+)D\.cnv/;
    my $sample_id=$hash{$2};
    
    my $prefix="$out/$sample_id.filter";
    my $prefix1="$out/$sample_id.filter1";
    my $prefix2="$out/$sample_id.filter2";
    my $prefix3="$out/$sample_id.final";
    
    # filter q0 >= 0.5  and e-val1 >= 0.01
    #print O "perl CNVnatorFilter.pl $f $prefix1.0.05 0.05;\n"; # limited effect of the number
    print O "perl CNVnatorFilter.pl $f $prefix1 0.05;\n";
    
    my $deletion_bed="$prefix1.del.bed";
    my $duplication_bed="$prefix1.dup.bed";
    
    # deletion and duplication; dose not ** within ** a gap
    print O2 "$bedtools intersect -a $deletion_bed -b $ngap -f 1|$bedtools intersect -a $deletion_bed -b - -v > $prefix2.del.bed;";
    print O2 "$bedtools intersect -a $duplication_bed -b $ngap -f 1| $bedtools intersect -a $duplication_bed -b - -v > $prefix2.dup.bed;\n";
    print O3 "cat $prefix2.del.bed $prefix2.dup.bed|sort -k1,2 > $prefix3.bed;";
    print O3 "perl bed_cnv.pl $prefix3.bed $f > $prefix3.cnv;\n";
    print O4 "perl annot.pl $bedtools $gene $prefix3.bed $prefix3.cnv> $prefix3.cnv.annot;\n"; 
}
# caution with this when you adapt it depend on your own population;   merge file each pop
print O5 "cat $out/B*.filter2.del.bed|sort -k1,1 -k2,2n |$bedtools merge -i - > $out/B.del.all.merge;\n"; 
print O5 "cat $out/B*.filter2.dup.bed|sort -k1,1 -k2,2n |$bedtools merge -i - > $out/B.dup.all.merge;\n";
print O5 "cat $out/A*.filter2.del.bed|sort -k1,1 -k2,2n |$bedtools merge -i - > $out/A.del.all.merge;\n";
print O5 "cat $out/A*.filter2.dup.bed|sort -k1,1 -k2,2n |$bedtools merge -i - > $out/A.dup.all.merge;\n";

`echo "#sample_id CNV_number average_length CNV_deletion_number CNV_duplication_number Genetic_CNV_number CNV_gene_number" > $out.annot`;
`cat $out/*annot >> $out.annot`;
#`echo "#sample_id CNV_number average_length CNV_deletion_number CNV_duplication_number Genetic_CNV_number CNV_gene_number" > $out.annot`;
`cat $out/B*annot > $out.annot.B`;
`cat $out/C*annot > $out.annot.C`;
`perl pvalue.pl $out.annot.B $out.annot.C`;

close O;
close O2;
close O3;
close O4;
close O5;

# sub
sub id1id2{
    my $input=shift;
    my %h=();
    open(I,"$input");
    while(<I>){
        chomp;
        #next if(/^\#/);
        my ($id1,$id2)=(split(/\s+/))[0,1];
        $h{$id1}=$id2;
    }
    close I;
    return %h;
}

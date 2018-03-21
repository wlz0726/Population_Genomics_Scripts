my @f=<01.annovar.input.pl.out/*avinput>;
foreach my $f(@f){
    print "perl /ifshk7/BC_PS/shenjuan2/public/annvar_hg19/table_annovar.pl $f /ifshk7/BC_PS/shenjuan2/public/annvar_hg19/ -buildver hg19 -remove -protocol refGene,ensGene,gerp++elem,phastConsElements46way,genomicSuperDups,esp6500_all,avsift,ljb26_all,clinvar_20140702,gwasCatalog,targetScanS,wgRna,rmsk -operation g,g,r,r,r,f,f,f,f,f,f,f,f -nastring . --outfile $f.anno -otherinfo; \n";
}

# need input.tped, input.tfam, poporder
# poporder file with one col (population name per line) or two cols (popname color)
perl get_treemix_input_from_tped.pl input.tfam input.tped

# OR

# plink1.07 --noweb --tfile input --freq --missing --within treemix.data.clust
# gzip plink.frq
# plink2treemix.py plink.frq.gz treemix.frq.gz
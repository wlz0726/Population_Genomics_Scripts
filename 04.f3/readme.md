# admix-f3
The 3-population test, is a formal test of admixture and can provide clear evidence of 
admixture, even if the gene flow events occurred hundreds of generations ago. If we want to Test 
if C has ancestry from populations related to A and B then we can perform the test f3(C; A, B). 

If C is unadmixed, then f3 (C ; A, B) has non-negative mean. 
If f3 (C ; A, B) has negative mean, in contrast, this implies that C is admixed with populations 
close to A and B (check the significance of the f3 mean and Z-score).



# Outgroup F3 Statistics

Outgroup F3 statistics are a useful analytical tool to understand population relationships. 
F3 statistics, just as F4 and F2 statistics measure allele frequency correlations between populations 
and were introduced by Nick Patterson in his [2012 paper](http://www.genetics.org/content/early/2012/09/06/genetics.112.145037).

F3 statistics are used for two purposes: 
i) as a test whether a target population (C) is admixed between two source populations (A and B), 
and 
ii) to measure shared drift between two test populations (A and B) from an outgroup (C). 
In this session ll use the second of these use cases.

F3 statistics are in both cases defined as the product of allele frequency differences between population C to A and B, respectively:

```
F3=<(c-a)(c-b)>
```

Here, `<>` denotes the average over all genotyped sites, and `a`, `b` and `c` denote the allele frequency in the three populations. 
Outgroup F3 statistics measure the amount of _shared genetic drift between two populations from a common ancestor. 
In a phylogenetic tree connecting A, B and C, Outgroup F3 statistics measure the common branch length from the outgroup, here indicated in red:
![image](http://ofr9vioug.bkt.clouddn.com/QQ20170607-151827@2x.png?imageView/2/w/500)

For computing F3 statistics including error bars, we will use the `qp3Pop` program from Admixtools. 
You can have a look at the readme for that tool under admixtools/README.3PopTest.

The README and name of the tools is actually geared towards the first use case of F3 described above, 
the test for admixture. But since the formula is exactly the same, we can use the same tool for Outgroup F3 Statistics as well. 
One ingredient that you need is a list of population triples. This should be a file with three population names in each row, 
separated by space, e.g.:

```
JK2134 AA Yoruba
JK2134 Abkhasian Yoruba
JK2134 Adygei Yoruba
JK2134 AG2 Yoruba
JK2134 Altai Yoruba
JK2134 Altaian Yoruba
...
```

Note that in this case the first population is a single sample, the second loops through all HO populations, and the third one is a fixed outroup, here Yoruba. 
For Non-African population studies you can use `Mbuti` as outgroup, which is commonly used as an unbiased outgroup to all Non-Africans.

## Analysing groups of samples (populations)
If you only analyse a single population, or a few, you can manually create lists of population triples. 
In that case, first locate the list of all Human Origins populations here: 
`HO_populations.txt`, and construct a file with the desired population triples using an awk-one-liner:

```
awk '{print "YourPopulation", $1, "Mbuti"}' $HO_populations > $OUT
```

Here, "YourPopulation" should be replaced by the population in you `*.ind.txt` file that you want to focus on, and "Mbuti" is the outgroup (pick another one if appropriate). Then, construct a parameter file like this:

```
genotypename:   /data/schiffels/GAworkshop/genotyping/MyProject.HO.eigenstrat.merged.geno.txt
snpname:   /data/schiffels/GAworkshop/genotyping/MyProject.HO.eigenstrat.merged.snp.txt
indivname:   /data/schiffels/GAworkshop/genotyping/MyProject.HO.eigenstrat.ind.txt
popfilename:  <YOUR_POPULATION_TRIPLE_LIST>
```

and run it via

```
qp3Pop -p $PARAMETER_FILE > $OUT
```

## Analysing individual samples
Change the ind.txt file, manually assigned each of my individuals its , which is simply called the same as the individual.

[more](http://gaworkshop.readthedocs.io/en/latest/contents/06_f3/f3.html)
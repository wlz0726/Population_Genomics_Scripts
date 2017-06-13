# Usage
prepare input.tped and input.tfam, change the plink and neighbor path in `01.runPlink.pl`, then run `perl 01.runPlink.pl`.
Then it will generate shell script to do the following things:
 
## calculate distance matrix with plink
```
plink1.9/plink --tfile input --distance square 1-ibs flat-missing --out 2.dist
```

## change to plylip format and prepare parameter file
```
perl 02.mdist2phylip.pl 2.dist.mdist input.tfam 3.phylip
perl 03.phylip.pl 3.phylip 4.outfile 4.out.tree;
```

## build neighbor-join tree with phylip
```
phylip-3.69/bin/neighbor 0<3.phylip.config
```

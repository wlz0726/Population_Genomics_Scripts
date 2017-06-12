#!/usr/bin/python

import sys, os, gzip

if len(sys.argv) < 3:
	print "plink2treemix.py [gzipped input file] [gzipped output file]"
	print "ERROR: improper command line"
	exit(1)
infile = gzip.open(sys.argv[1])
outfile = gzip.open(sys.argv[2], "w")


pop2rs = dict()
rss = list()
rss2 = set()

line = infile.readline()
line = infile.readline()
while line:
    line = line.strip().split()
    rs = line[1]
    pop = line[2]
    mc = line[6]
    total = line[7]
    if rs not in rss2: 
    	rss.append(rs)
    rss2.add(rs)
    if pop2rs.has_key(pop)==0:
        pop2rs[pop] =  dict()
    if pop2rs[pop].has_key(rs)==0:
        pop2rs[pop][rs] = " ".join([mc, total])
    line = infile.readline()

pops = pop2rs.keys()
for pop in pops:
    print >> outfile, pop,
print >> outfile, ""

for rs in rss:
    for pop in pops:
        tmp = pop2rs[pop][rs].split()
        c1 = int(tmp[0])
        c2 = int(tmp[1])
        c3 = c2-c1
        print >> outfile, ",".join([str(c1), str(c3)]),
    print >> outfile, ""


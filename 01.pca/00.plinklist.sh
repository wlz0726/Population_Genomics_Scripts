# need 000.*.plinklist  sample list
for i in 000.*.plinklist
do awk '{print $1}' $i|sort -u > $i.pop
done
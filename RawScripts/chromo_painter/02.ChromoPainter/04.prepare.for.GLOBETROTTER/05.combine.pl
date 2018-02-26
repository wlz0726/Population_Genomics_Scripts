my $dir=shift;

print "/home/wanglizhong/bin/fs chromocombine -o $dir.combine";
for(my $i=1;$i<30;$i++){
    next if($i==6 || $i==24);
    print " $dir/$i";
}
print "\n";

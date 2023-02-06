# Unzip raw-data downloads from PACE and move the model_timing_stats file to the
# main data directory.

for i in *.zip; do
    echo $i
    j=${i/exp-donahue-/}
    k=${j/.zip/}
    echo $k
    rm -rf $k
    mkdir $k;
    (cd $k
     unzip -q ../$i
     f=`ls timing.*gz`
     tar xfz $f
     g=${f/.tar.gz/}
     cp $g/model_timing_stats ../../scream-v1-production.$k-model_timing_stats)
done

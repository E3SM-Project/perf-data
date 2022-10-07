# Untar timing archives and copy model_timing_stats to data/.

datadir=`pwd`/data
bdir=/gpfs/alpine/cli115/proj-shared/ambradl/e3sm_scratch

cd $bdir

for d in `ls -d scream-v1-scaling1-*`; do
    cd $d/run
    for tt in `ls timing*gz`; do
        tar xfz $tt
        t=${tt/.tar.gz/}
        cp $t/model_timing_stats $datadir/$d-$t-model_timing_stats
    done
    cd ../../
done

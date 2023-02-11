# Untar timing archives and copy model_timing_stats to data/.

datadir=`pwd`/data
bdir=/gpfs/alpine/cli133/proj-shared/ambradl/e3sm_scratch/frontier

cd $bdir

for d in `ls -d frontier-v1-scaling1-*`; do
    cd $d/run
    for tt in `ls timing*gz`; do
        tar xfz $tt
        t=${tt/.tar.gz/}
        cp $t/model_timing_stats $datadir/$d-$t-model_timing_stats
    done
    cd ../../
done

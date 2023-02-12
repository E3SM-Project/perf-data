casedir=$1
rundir=$2
nnode=$3
echo "Case dir: $casedir"
echo "Run dir: $rundir"
echo "nnode: $nnode"

job_monitor_started=false
while true; do
    if [ -e $rundir/timing*gz ]; then
        echo "Got one; exiting."
        exit
    fi
    squeue -u ambradl | grep " $nnode "
    if [ $? == 0 ]; then
        if ! $job_monitor_started; then
            ln=`squeue -u ambradl | grep " $nnode "`
            toks=( $ln )
            jobid=${toks[0]}
            python jobmonitor.py $rundir $jobid
            job_monitor_started=true
        fi
    else
        cd $casedir
        ./case.submit
        cd ..
        job_monitor_started=false
    fi
    sleep 180
done

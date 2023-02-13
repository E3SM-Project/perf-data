casedir=$1
rundir=$2
nnode=$3
filter=$4
echo "Case dir: $casedir"
echo "Run dir: $rundir"
echo "nnode: $nnode"
echo "filter: $filter"

function qread() {
    squeue -o "%.8i %.4D %.6P %.80j %.16u %.2t %.10M %.10l" -u ambradl | grep " $nnode " | grep $filter
}

job_monitor_started=false
while true; do
    if [ -e stop.${nnode} ]; then
        echo "Stopping at user request."
        exit
    fi
    if [ -e $rundir/timing*gz ]; then
        echo "Got one; exiting."
        exit
    fi
    qread
    if [ $? == 0 ]; then
        if ! $job_monitor_started; then
            ln=`qread`
            echo $ln
            toks=( $ln )
            jobid=${toks[0]}
            echo "jobid $jobid"
            python jobmonitor.py $rundir $jobid
            job_monitor_started=true
        fi
    else
        cd $casedir
        ./case.submit
        cd ..
        job_monitor_started=false
    fi
    sleep 60
done

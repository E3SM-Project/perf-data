if [ -z "$1" ]; then
    echo "Must provide number of nodes: $0 <number>"
    exit 1
fi

e3sm_top_dir=/home/tccleve/E3SM-Project/E3SM_Main/E3SM
run_script_dir=/home/tccleve/E3SM-Project/E3SM_Main/perf-data/screamv1-aurora-apr2025
case_dir=/lus/flare/projects/E3SM_Dec/tccleve/scratch/aurora-timings

nnodes=$1
pernode=12

compset=F2010-SCREAMv1
#res=ne30pg2_ne30pg2
res=ne1024pg2_ne1024pg2

prefix=aurora-v1-scaling1-no-threading
cname=$prefix-nnodes${nnodes}.$res.$compset

if [ "$nnodes" -le 2048 ]; then
    queue=prod
else
    queue=prod-large
fi
walltime=2:00:00

compiler=oneapi-ifxgpu
machine=aurora

cd $case_dir
rm -rf $cname

$e3sm_top_dir/cime/scripts/create_newcase --case ${cname} --compset ${compset} --res ${res} \
  --machine ${machine} --compiler ${compiler} --output-root $case_dir 
cd $cname

./xmlchange JOB_QUEUE=$queue
./xmlchange JOB_WALLCLOCK_TIME=$walltime
./xmlchange STOP_OPTION=nhours
./xmlchange STOP_N=12

./xmlchange HIST_N=999; ./xmlchange HIST_OPTION=nyears
./xmlchange REST_N=999; ./xmlchange REST_OPTION=nyears

./xmlchange NTASKS=$(($pernode * $nnodes))
#./xmlchange LND_NTHRDS=8

./xmlchange SCREAM_CMAKE_OPTIONS="`./xmlquery -value SCREAM_CMAKE_OPTIONS | sed 's/SCREAM_NUM_VERTICAL_LEV [0-9][0-9]*/SCREAM_NUM_VERTICAL_LEV 128/'`"

./case.setup

cp $run_script_dir/nooutput.yaml .
./atmchange scorpio::output_yaml_files=./nooutput.yaml
./xmlchange RUN_STARTDATE="2013-10-01"
./atmchange disable_diagnostics=true
./atmchange statefreq=99999999

./case.build
./case.submit



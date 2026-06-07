if [ "$#" -lt 4 ] || [ "$#" -gt 5 ]; then
    echo "Usage: $0 <nnodes> <case_prefix> <wallclock> <queue> [mpilib]"
    echo "  mpilib defaults to mpich"
    exit 1
fi

nnodes=$1
prefix=$2
walltime=$3
queue=$4
mpilib=${5:-mpich1024}

e3sm_top_dir=/home/tccleve/E3SM-Project/E3SM_Main/E3SM
run_script_dir=/home/tccleve/E3SM-Project/E3SM_Main/perf-data/screamv1-aurora-apr2025/hackathon2026
case_dir=/lus/flare/projects/E3SM_Dec/tccleve/scratch/hackathon2026/${mpilib}

compset=F2010-SCREAMv1
res=ne1024pg2_ne1024pg2

cname=${prefix}-${mpilib}.nnodes${nnodes}.$res.$compset

compiler=oneapi-ifxgpu
machine=aurora

cd $case_dir
rm -rf $cname

$e3sm_top_dir/cime/scripts/create_newcase --case ${cname} --compset ${compset} --res ${res} \
  --machine ${machine} --compiler ${compiler} --mpilib ${mpilib} --output-root $case_dir 
cd $cname

./xmlchange JOB_WALLCLOCK_TIME=$walltime
./xmlchange STOP_OPTION=nhours
./xmlchange STOP_N=12

./xmlchange HIST_N=999; ./xmlchange HIST_OPTION=nyears
./xmlchange REST_N=999; ./xmlchange REST_OPTION=nyears

pernode=12
./xmlchange NTASKS=$(($pernode * $nnodes))
#./xmlchange LND_NTHRDS=8

./xmlchange SCREAM_CMAKE_OPTIONS="SCREAM_NP 4 SCREAM_NUM_VERTICAL_LEV 128 SCREAM_NUM_TRACERS 10 SCREAM_SMALL_KERNELS False"

./case.setup

./xmlchange CHARGE_ACCOUNT=gpu_hack
./xmlchange JOB_QUEUE=${queue} --force

cp $run_script_dir/nooutput.yaml .
./atmchange scorpio::output_yaml_files=./nooutput.yaml
./xmlchange RUN_STARTDATE="2013-10-01"
./atmchange disable_diagnostics=true
./atmchange statefreq=99999999

./case.build
./case.submit




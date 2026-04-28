#!/bin/bash

if [ -z "$1" ]; then
    echo "Must provide number of nodes: $0 <number>"
    exit 1
fi
nnodes=$1

echo "Running with $1 node(s)."

e3sm_top_dir=/home/tccleve/E3SM-Project/E3SM_Main/E3SM
run_script_dir=/home/tccleve/E3SM-Project/E3SM_Main/perf-data/screamv1-aurora-apr2025/hackathon2026
case_dir=/lus/flare/projects/E3SM_Dec/tccleve/scratch/hackathon2026

compset=F2010-SCREAMv1
res=ne4pg2_ne4pg2

prefix=hpctoolkit
cname=$prefix.$res.$compset.nnodes${nnodes}

compiler=oneapi-ifxgpu
machine=aurora
mpilib=mpich1024

cd $case_dir
rm -rf $cname

$e3sm_top_dir/cime/scripts/create_newcase --case ${cname} --compset ${compset} --res ${res} \
  --machine ${machine} --compiler ${compiler} --mpilib ${mpilib} --output-root $case_dir 
cd $cname

walltime=0:30:00
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

cp $run_script_dir/../nooutput.yaml .
./atmchange scorpio::output_yaml_files=./nooutput.yaml
./xmlchange RUN_STARTDATE="2013-10-01"
./atmchange disable_diagnostics=true
./atmchange statefreq=99999999

# Replace exec command
f="${case_dir}/${cname}/env_mach_specific.xml"
sed -i.bak \
  's#${EXEROOT}/e3sm\.exe#hpcrun -e CPUTIME -e gpu=level0 -tt ${EXEROOT}/e3sm\.exe#g' \
  "$f"

./case.build
./case.submit



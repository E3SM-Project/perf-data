scream=~/repo/SCREAMalt
# tag https://github.com/E3SM-Project/scream/releases/tag/archive%2Fscreamv1-frontier-feb2023-rocm51

nnodes=$1
pernode=8

compset=F2010-SCREAMv1
res=ne1024pg2_ne1024pg2

prefix=frontier-v1-scaling1-rocm51
cname=$prefix-nnodes${nnodes}.$res.$compset

queue=batch
compiler=crayclang-scream
machine=frontier-scream-gpu

rm -rf $cname
$scream/cime/scripts/create_newcase --case ${cname} --compset ${compset} --res ${res} \
  -mach ${machine} --compiler ${compiler} --handle-preexisting-dirs u \
  --case-group $prefix
cd $cname

./xmlchange JOB_QUEUE=$queue
./xmlchange JOB_WALLCLOCK_TIME=2:00:00
./xmlchange STOP_OPTION=nhours
./xmlchange STOP_N=12

./xmlchange HIST_N=9999999; ./xmlchange HIST_OPTION=nyears
./xmlchange REST_N=9999999; ./xmlchange REST_OPTION=nyears
./xmlchange PIO_NETCDF_FORMAT="64bit_data"

./xmlchange NTASKS=$(($pernode * $nnodes))
./xmlchange MAX_TASKS_PER_NODE=56
./xmlchange MAX_MPITASKS_PER_NODE=8
./xmlchange LND_NTHRDS=7

./xmlchange SCREAM_CMAKE_OPTIONS="SCREAM_NUM_VERTICAL_LEV 128 SCREAM_NUM_TRACERS 10 HOMMEXX_MPI_ON_DEVICE On"

./case.setup

./atmchange Scorpio::output_yaml_files=/ccs/home/ambradl/summit/nooutput.yaml
./xmlchange RUN_STARTDATE="2013-10-01"
./atmchange disable_diagnostics=true
./atmchange frequency_units=nsteps Frequency=99999999
./atmchange statefreq=99999999

./case.build
./case.submit

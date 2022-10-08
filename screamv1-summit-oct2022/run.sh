scream=~/repo/SCREAM
# $ git log -n 2 --oneline
# 1cd65fd370 (HEAD -> sl-mpionhost, fork/sl-mpionhost) Use different modules on Summit to work around current pr# oblem with missing dir.
# e4e4edd234 Hommexx/SL: Implement HOMMEXX_MPI_ON_DEVICE=Off in SL transport.
# tag archive/screamv1-summit-oct2022

nnodes=$1
pernode=6
ntask=$(($pernode * $nnodes))

compset=F2010-SCREAMv1
res=ne1024pg2_ne1024pg2

prefix=scream-v1-scaling2
cname=$prefix-nnodes${nnodes}.$res.$compset

queue=batch
compiler=gnugpu
machine=summit

rm -rf $cname
$scream/cime/scripts/create_newcase --case ${cname} --compset ${compset} --res ${res} \
  -mach ${machine} --compiler ${compiler} --handle-preexisting-dirs u \
  --case-group $prefix
cd $cname

./xmlchange JOB_QUEUE=$queue
./xmlchange JOB_WALLCLOCK_TIME=1:00:00
./xmlchange STOP_OPTION=nhours
./xmlchange STOP_N=12

./xmlchange HIST_N=9999999; ./xmlchange HIST_OPTION=nyears
./xmlchange REST_N=9999999; ./xmlchange REST_OPTION=nyears
./xmlchange NTASKS=$ntask
./xmlchange MAX_TASKS_PER_NODE=84
./xmlchange MAX_MPITASKS_PER_NODE=6
./xmlchange LND_NTHRDS=14
./xmlchange PIO_NETCDF_FORMAT="64bit_data"

./xmlchange SCREAM_CMAKE_OPTIONS="SCREAM_NUM_VERTICAL_LEV 128 SCREAM_NUM_TRACERS 10 HOMMEXX_MPI_ON_DEVICE Off"

./case.setup

cp /ccs/home/ambradl/summit/user_nl_elm_20220919 user_nl_elm

./atmchange Scorpio::output_yaml_files=/ccs/home/ambradl/summit/nooutput.yaml
./xmlchange RUN_STARTDATE="0001-10-01"
./atmchange disable_diagnostics=true
./atmchange frequency_units=nsteps Frequency=99999999
./atmchange statefreq=99999999

./case.build
./case.submit

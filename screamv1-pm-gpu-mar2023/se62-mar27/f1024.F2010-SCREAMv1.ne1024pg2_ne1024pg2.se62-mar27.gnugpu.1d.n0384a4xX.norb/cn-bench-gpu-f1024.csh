#! /bin/csh
# https://acme-climate.atlassian.net/wiki/spaces/NGDNA/pages/3518235263/SCREAMv1+ne1024+Summit+Runs
# https://github.com/E3SM-Project/perf-data/blob/main/screamv1-frontier-feb2023
# https://github.com/E3SM-Project/perf-data/blob/main/screamv1-frontier-feb2023/nooutput.yaml
set compset=F2010-SCREAMv1
set mach=pm-gpu
set res=ne1024pg2_ne1024pg2
set repo=se62-mar27
set compiler=gnugpu
set account=e3sm
set q=regular
set wt="3:10:00"

set wdir="$PSCRATCH/e3sm_scratch/$mach/$repo"
set here=`pwd`
echo "here=$here 0=$0"

#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n0384a4xX.nor.blob"
set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n0384a4xX.norb"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.2d.n0512a4xX.nor"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.2d.n1024a4xX.norb"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.2d.n1536a4xX.nor"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.2d.n1536a4xX.norb"

#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n0256a4xX.nor.ctk117.mpich8124"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n0384a4xX.nor.modup.FICCM"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n1024a4xX.nor.ctk117.mpich8124"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n1536a4xX.nor.ctk117.mpich8124"

## Some provenance information
set repodir=../..
set githash=`git --git-dir $repodir/.git rev-parse HEAD`
set masterhash=`git --git-dir $repodir/.git log -n 1 --pretty=format:"%H" origin/master`
set masterhash_screamdocs=`git --git-dir $repodir/../scream-docs/.git log -n 1 --pretty=format:"%H" origin/master`

echo "create_newcase --case $cn --res $res --mach $mach --compiler $compiler --compset $compset --project $account --walltime=$wt --queue=$q"
create_newcase --case $cn --res $res --mach $mach --compiler $compiler --compset $compset --project $account --walltime=$wt --queue=$q

#set np=6144 # 1536*4
#set np=6136
#set np=4096 # 1024*4
#set np=2048 # 512*4
set np=1536 # 384*4
#set np=1024 # 256*4
set mpi_per_node=4
set ntatm=16
set ntcpl=1
set nt=8

cd $cn
cp $here/$0 .

@ mtpn = (($nt * $mpi_per_node))
./xmlchange --file env_mach_pes.xml MAX_TASKS_PER_NODE=$mtpn
echo nt=$nt mtpn=$mtpn

#./xmlchange --file env_run.xml STOP_OPTION="nsteps"
#./xmlchange --file env_run.xml STOP_N="36"
./xmlchange --file env_run.xml STOP_OPTION="ndays"
./xmlchange --file env_run.xml STOP_N="1"

./xmlchange HIST_N=9999999; ./xmlchange HIST_OPTION=nyears
./xmlchange REST_N=9999999; ./xmlchange REST_OPTION=nyears

echo "master hash: $masterhash" > GIT_INFO.txt
echo "master hash for output files: $masterhash_screamdocs" >> GIT_INFO.txt

./xmlchange PIO_NETCDF_FORMAT="64bit_data"

./xmlchange --file env_mach_pes.xml MAX_TASKS_PER_NODE=256
./xmlchange --file env_mach_pes.xml MAX_MPITASKS_PER_NODE=$mpi_per_node

./xmlchange --file env_mach_pes.xml NTASKS_ATM="$np"
./xmlchange --file env_mach_pes.xml NTASKS_LND="$np"
./xmlchange --file env_mach_pes.xml NTASKS_ICE="$np"
./xmlchange --file env_mach_pes.xml NTASKS_OCN="$np"
./xmlchange --file env_mach_pes.xml NTASKS_CPL="$np"
./xmlchange --file env_mach_pes.xml NTASKS_ROF="$np"
./xmlchange --file env_mach_pes.xml NTASKS_GLC="1"
./xmlchange --file env_mach_pes.xml NTASKS_WAV="1"

./xmlchange --file env_mach_pes.xml NTHRDS_ATM="$ntatm"
./xmlchange --file env_mach_pes.xml NTHRDS_LND="$nt"
./xmlchange --file env_mach_pes.xml NTHRDS_ICE="$nt"
./xmlchange --file env_mach_pes.xml NTHRDS_OCN="$nt"
./xmlchange --file env_mach_pes.xml NTHRDS_CPL="$ntcpl"
./xmlchange --file env_mach_pes.xml NTHRDS_GLC="1"
./xmlchange --file env_mach_pes.xml NTHRDS_ROF="$nt"
./xmlchange --file env_mach_pes.xml NTHRDS_WAV="1"

./xmlchange --file env_run.xml GMAKE_J="17"
./xmlchange SCREAM_CMAKE_OPTIONS="SCREAM_NP 4 SCREAM_NUM_VERTICAL_LEV 128 SCREAM_NUM_TRACERS 10"
./xmlquery SCREAM_CMAKE_OPTIONS

pwd

case.setup >& csout.txt

cat <<EOF >> spiffy.yaml
Averaging Type: Average
filename_prefix: nooutput.scream.hi
Checkpoint Control:
  Frequency: 9999999
  MPI Ranks in Filename: false
  Timestamp in Filename: true
  avg_type_in_filename: false
  frequency_in_filename: false
  frequency_units: nyears
Fields:
  Physics PG2:
    Field Names:
    - ps
Max Snapshots Per File: 744
output_control:
  Frequency: 9999999
  MPI Ranks in Filename: false
  Timestamp in Filename: true
  avg_type_in_filename: false
  frequency_in_filename: false
  frequency_units: nyears
EOF
./atmchange Scorpio::output_yaml_files=$cn/spiffy.yaml
#./xmlchange run_exe="~/stingray/simpleTests/blob.sh `xmlquery --value run_exe`"

./xmlchange RUN_STARTDATE="2013-10-01"
./atmchange disable_diagnostics=true
./atmchange frequency_units=nsteps Frequency=99999999
./atmchange statefreq=99999999


echo " building"

case.build >& buildout.txt

ls -l bld/*.exe*

./preview_run >& prout.txt
cat prout.txt

echo " submitting"

#lfs setstripe -c 32 run

case.submit -a="-t $wt" >& submitout.txt

echo " done"

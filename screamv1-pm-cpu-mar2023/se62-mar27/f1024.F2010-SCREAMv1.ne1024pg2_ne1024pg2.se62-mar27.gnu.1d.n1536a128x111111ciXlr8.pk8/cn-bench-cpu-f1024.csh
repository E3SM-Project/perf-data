#! /bin/csh
set compset=F2010-SCREAMv1
set mach=pm-cpu
set res=ne1024pg2_ne1024pg2
set repo=se62-mar27
set compiler=gnu
set account=e3sm
set q=regular
set wt="3:14:00"

set wdir="$PSCRATCH/e3sm_scratch/$mach/$repo"
#set wdir="/global/cfs/cdirs/e3sm/ndk/e3sm_scratch/$mach/$repo"
set here=`pwd`
echo "here=$here 0=$0"

#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n0512a32x8c4.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n0512a128x111121ciZlX.pk1"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n0512a128x111111clirZ.pk1"

#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.6s.n1024a128x1ciYlX.pk8.blob"

#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n1024a128x111221ciXl8.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n1024a128x111121clrXl8.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n1024a128x111111cirXl4.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n1024a128x111111ciXlr8.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n1024a128x111111cilX.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n2048a128x111111ciXl2.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n1536a128x111111ciXl2.pk8"

#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n2048a128x111111ciXlr8.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.36s.n2048a128x111111ciXl4.pk8"

#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n1024a128x111111ciXlr8.pk8"
set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n1536a128x111111ciXlr8.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n2048a128x111111ciXl8.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n2048a128x111111ciXlr8.pk8"
#set cn="$wdir/f1024.$compset.$res.$repo.$compiler.1d.n3072a128x111111ciX.pk8"

## Some provenance information
set repodir=../..
set githash=`git --git-dir $repodir/.git rev-parse HEAD`
set masterhash=`git --git-dir $repodir/.git log -n 1 --pretty=format:"%H" origin/master`
set masterhash_screamdocs=`git --git-dir $repodir/../scream-docs/.git log -n 1 --pretty=format:"%H" origin/master`

echo "create_newcase --case $cn --res $res --mach $mach --compiler $compiler --compset $compset --project $account --walltime=$wt --queue=$q"
create_newcase --case $cn --res $res --mach $mach --compiler $compiler --compset $compset --project $account --walltime=$wt --queue=$q

#set np=393216 # 3072*128
#set np=262144 # 2048*128
set np=196608 # 1536 * 128
#set np=131072 # 1024*128
#set np=65536 # 512*128
#set np=49152 # 384*128 768*64
#set np=32768 # 512*64
#set np=3200 # 200 * 16
#set np=25600 # 200*128
#set np=24576 # 192*128  or 384*64 or 768*32
#set np=16384 # 256*64 512*32
#set np=14336 # 448*32
#set np=8192 # 128*64 512*16 256*32
#set np=7168 # 448*16
#set np=6656 # 416*16
#set np=25600 # 400*64
#set np=12800 # 400*32
#set np=12288 # 384*32 192*64 96*128
#set np=6400 # 400*16
#set np=6144 #  384*16 192*32
#set np=4096 # 512*8
#set np=3072 #  384*8  192*16
#set np=1536 #  384*4
#set np=2048 # 256*8
set mpi_per_node=128
set ntatm=1
set ntcpl=1
set ntlnd=1
set ntice=1
set nt=$ntatm
set stridc=16
set stridi=16
set stridl=8
set stridr=8

cd $cn
cp $here/$0 .

@ mtpn = (($nt * $mpi_per_node))
./xmlchange --file env_mach_pes.xml MAX_TASKS_PER_NODE=$mtpn
echo nt=$nt mtpn=$mtpn

#./xmlchange --file env_run.xml STOP_OPTION="nsteps"
#./xmlchange --file env_run.xml STOP_N="6"
./xmlchange --file env_run.xml STOP_OPTION="ndays"
./xmlchange --file env_run.xml STOP_N="1"

./xmlchange --file env_run.xml REST_OPTION="nsteps"
./xmlchange --file env_run.xml REST_N="99936"

#./xmlchange AVGHIST_OPTION=ndays
#./xmlchange AVGHIST_N=1

echo "master hash: $masterhash" > GIT_INFO.txt
echo "master hash for output files: $masterhash_screamdocs" >> GIT_INFO.txt

./xmlchange PIO_NETCDF_FORMAT="64bit_data"

./xmlchange --file env_mach_pes.xml MAX_TASKS_PER_NODE=256
#./xmlchange --file env_mach_pes.xml PES_PER_NODE=$mpi_per_node
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
./xmlchange --file env_mach_pes.xml NTHRDS_LND="$ntlnd"
./xmlchange --file env_mach_pes.xml NTHRDS_ICE="$ntice"
./xmlchange --file env_mach_pes.xml NTHRDS_OCN="$nt"
./xmlchange --file env_mach_pes.xml NTHRDS_CPL="$ntcpl"
./xmlchange --file env_mach_pes.xml NTHRDS_GLC="1"
./xmlchange --file env_mach_pes.xml NTHRDS_ROF="$nt"
./xmlchange --file env_mach_pes.xml NTHRDS_WAV="1"

@ npcpl = (($np / $stridc))
@ npice = (($np / $stridi))
@ nplnd = (($np / $stridl))
@ nprof = (($np / $stridr))
./xmlchange --file env_mach_pes.xml NTASKS_CPL="$npcpl"
./xmlchange --file env_mach_pes.xml PSTRID_CPL="$stridc"
./xmlchange --file env_mach_pes.xml NTASKS_ICE="$npice"
./xmlchange --file env_mach_pes.xml PSTRID_ICE="$stridi"
./xmlchange --file env_mach_pes.xml NTASKS_OCN="$npice"
./xmlchange --file env_mach_pes.xml PSTRID_OCN="$stridi"
./xmlchange --file env_mach_pes.xml NTASKS_LND="$nplnd"
./xmlchange --file env_mach_pes.xml PSTRID_LND="$stridl"
./xmlchange --file env_mach_pes.xml NTASKS_ROF="$nprof"
./xmlchange --file env_mach_pes.xml PSTRID_ROF="$stridr"

./xmlchange --file env_run.xml GMAKE_J="17"
./xmlchange SCREAM_CMAKE_OPTIONS="SCREAM_NP 4 SCREAM_NUM_VERTICAL_LEV 128 SCREAM_NUM_TRACERS 10"
./xmlchange --append SCREAM_CMAKE_OPTIONS="SCREAM_PACK_SIZE 8"
./xmlquery SCREAM_CMAKE_OPTIONS

pwd

case.setup >& csout.txt

#./atmchange disable_diagnostics=True

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

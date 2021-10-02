# Run:
#   bash runf.sh (maint1p0|v2p0p0) node-count
# Node counts of interest:
#   5 10 20 38 43 45 49 51 57 59 68 70 85
#   g  g  b  b  p  g  p  g  p  g  p  g  b
# These were obtained by running
#   v2op.list_chrys_good_nodecounts(30)
# and subselecting several node counts that favor either GLL and pg2, roughly in
# alternating order. The annotation after each node count above indicates which
# is favored: g for GLL, p for pg2, and b for both.

branch=$1
nodecount=$2

# E3SM repos obtained with:
#   git clone git@github.com:E3SM-Project/E3SM.git --single-branch --branch maint-1.0 e3sm-maint1p0
#   git clone git@github.com:E3SM-Project/E3SM.git --single-branch --branch v2.0.0 e3sm-v2p0p0
# Then cd into the base directory and run
#   git submodule update --init --recursive

e3sm=/home/ac.ambradl/v2/overview/e3sm-$branch
wcid=e3sm

if [[ $branch == maint1p0 ]]; then
    res=ne30_ne30
    compset=FC5AV1C-L
    tfactor=2
elif [[ $branch == v2p0p0 ]]; then
    res=ne30pg2_ne30pg2
    compset=F2010-CICE
    tfactor=1
else
    echo "ERROR: Not a branch:" $branch
    exit
fi

if [[ $nodecount -le 0 ]]; then
    echo "ERROR: Invalid nodecount: " $nodecount
fi

case=$compset.$res.$nodecount
echo $case
rm -rf $case

walltime=`python3 walltime.py $tfactor $nodecount`
echo "$nodecount nodes: walltime $minutes"

$e3sm/cime/scripts/create_newcase \
    -case $case -compset $compset -res $res \
    --machine chrysalis --compiler intel --project $wcid \
    --handle-preexisting-dirs u \
    --walltime $walltime

cd $case

ncore=64
./xmlchange GMAKE_J=$ncore

./xmlchange NTASKS=$(( $nodecount * $ncore ))
./xmlchange NTHRDS=1
./xmlchange MAX_MPITASKS_PER_NODE=$ncore
./xmlchange MAX_TASKS_PER_NODE=$ncore

./xmlchange STOP_OPTION=nmonths
./xmlchange STOP_N=3
./xmlchange REST_OPTION=nmonths
./xmlchange REST_N=3
./xmlchange HIST_OPTION=nmonths
./xmlchange HIST_N=3

./case.setup
./case.build
./case.submit

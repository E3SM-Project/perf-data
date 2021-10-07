branch=$1
pelayout=$2

e3sm=/home/ac.ambradl/v2/overview/e3sm-$branch
wcid=e3sm

prefix=v2-overview-wccase-chrysalis-r0

if [[ $branch == maint1p0 ]]; then
    res=ne30_oECv3
    compset=A_WCYCL1850S_CMIP6
    tfactor=2
    casegrouparg="" # not available in maint-1.0
elif [[ $branch == v2p0p0 ]]; then
    res=ne30pg2_EC30to60E2r2
    compset=WCYCL1850
    tfactor=1
    casegrouparg="--case-group $prefix"
else
    echo "ERROR: Not a branch:" $branch
    exit
fi

if [[ $pelayout == S ]]; then
    walltime='03:00:00'
elif [[ $pelayout == M ]]; then
    walltime='02:00:00'
elif [[ $pelayout == L ]]; then
    walltime='01:00:00'
else
    echo "ERROR: Not a valid peylaout:" $pelayout
    exit
fi

case=$prefix.$compset.$res.$pelayout
echo $case
rm -rf $case

$e3sm/cime/scripts/create_newcase \
    -case $case -compset $compset -res $res $casegrouparg \
    --machine chrysalis --compiler intel --project $wcid \
    --handle-preexisting-dirs u \
    --walltime $walltime --pecount $pelayout

cd $case

ncore=64
./xmlchange GMAKE_J=$ncore

./xmlchange STOP_OPTION=nmonths
./xmlchange STOP_N=3
./xmlchange REST_OPTION=nmonths
./xmlchange REST_N=3
./xmlchange HIST_OPTION=nmonths
./xmlchange HIST_N=3

./case.setup
./case.build
./case.submit

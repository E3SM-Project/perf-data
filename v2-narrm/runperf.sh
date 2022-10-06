config=$1
pelayout=$2

e3sm=/home/ac.ambradl/v2/rrm/e3sm-maint-2.0
# $ git log -n 1 --oneline
# cdf65368ba (HEAD -> maint-2.0, origin/maint-2.0) Merge branch 'azamat/maint-2.0/sync-pgi-master' into maint-2.0 (PR #5101)

wcid=e3sm

# r2 uses a mod'ed L
prefix=v2-narrm-wccase-chrysalis-r2
casegrouparg="--case-group $prefix"

compset=WCYCL20TR
if [[ $config == LR ]]; then
    res=ne30pg2_EC30to60E2r2
elif [[ $config == NARRM ]]; then
    res=northamericax4v1pg2_WC14to60E2r3
else
    echo "ERROR: Not a config:" $config
    exit
fi

pecountarg="--pecount $pelayout"

if [[ $pelayout == T ]]; then
    walltime='08:00:00'
elif [[ $pelayout == XS ]]; then
    walltime='05:00:00'
elif [[ $pelayout == S ]]; then
    walltime='05:00:00'
elif [[ $pelayout == M ]]; then
    walltime='03:00:00'
elif [[ $pelayout == L ]]; then
    walltime='02:00:00'
else
    pecountarg=
    walltime='08:00:00'
fi

walltime='00:45:00'

case=$prefix.$compset.$res.$pelayout
echo $case
rm -rf $case

$e3sm/cime/scripts/create_newcase \
    -case $case -compset $compset -res $res $casegrouparg \
    --machine chrysalis --compiler intel --project $wcid \
    --handle-preexisting-dirs u \
    --walltime $walltime $pecountarg

cd $case

ncore=64
./xmlchange GMAKE_J=$ncore

./xmlchange RUN_STARTDATE="1850-01-01"

./xmlchange --id CAM_CONFIG_OPTS --append --val='-cosp'

ndays=90
./xmlchange STOP_OPTION=ndays
./xmlchange STOP_N=$ndays
./xmlchange REST_OPTION=ndays
./xmlchange REST_N=$ndays
./xmlchange HIST_OPTION=ndays
./xmlchange HIST_N=$ndays

if [[ $pecountarg == "" ]]; then
    ./xmlchange NTASKS=$(( $pelayout * $ncore ))
    ./xmlchange NTHRDS=1
    ./xmlchange ROOTPE=0
    ./xmlchange MAX_MPITASKS_PER_NODE=$ncore
    ./xmlchange MAX_TASKS_PER_NODE=$ncore
fi

cat << EOF >> user_nl_eam
 nhtfrq =   0,-24,-6,-6,-3,-24,0
 mfilt  = 1,30,120,120,240,30,1
 avgflag_pertape = 'A','A','I','A','A','A','I'
 fexcl1 = 'CFAD_SR532_CAL', 'LINOZ_DO3', 'LINOZ_DO3_PSC', 'LINOZ_O3CLIM', 'LINOZ_O3COL', 'LINOZ_SSO3', 'hstobie_linoz'
 fincl1 = 'extinct_sw_inp','extinct_lw_bnd7','extinct_lw_inp','CLD_CAL', 'TREFMNAV', 'TREFMXAV'
 fincl2 = 'FLUT','PRECT','U200','V200','U850','V850','Z500','OMEGA500','UBOT','VBOT','TREFHT','TREFHTMN:M','TREFHTMX:X','QREFHT','TS','PS','TMQ','TUQ','TVQ','TOZ', 'FLDS', 'FLNS', 'FSDS', 'FSNS', 'SHFLX', 'LHFLX', 'TGCLDCWP', 'TGCLDIWP', 'TGCLDLWP', 'CLDTOT', 'T250', 'T200', 'T150', 'T100', 'T050', 'T025', 'T010', 'T005', 'T002', 'T001', 'TTOP', 'U250', 'U150', 'U100', 'U050', 'U025', 'U010', 'U005', 'U002', 'U001', 'UTOP', 'FSNT', 'FLNT'
 fincl3 = 'PSL','T200','T500','U850','V850','UBOT','VBOT','TREFHT', 'Z700', 'TBOT:M'
 fincl4 = 'FLUT','U200','U850','PRECT','OMEGA500'
 fincl5 = 'PRECT','PRECC','TUQ','TVQ','QFLX','SHFLX','U90M','V90M'
 fincl6 = 'CLDTOT_ISCCP','MEANCLDALB_ISCCP','MEANTAU_ISCCP','MEANPTOP_ISCCP','MEANTB_ISCCP','CLDTOT_CAL','CLDTOT_CAL_LIQ','CLDTOT_CAL_ICE','CLDTOT_CAL_UN','CLDHGH_CAL','CLDHGH_CAL_LIQ','CLDHGH_CAL_ICE','CLDHGH_CAL_UN','CLDMED_CAL','CLDMED_CAL_LIQ','CLDMED_CAL_ICE','CLDMED_CAL_UN','CLDLOW_CAL','CLDLOW_CAL_LIQ','CLDLOW_CAL_ICE','CLDLOW_CAL_UN'
 fincl7 = 'O3', 'PS', 'TROP_P'

EOF

cat << EOF >> user_nl_elm
 hist_dov2xy = .true.,.true.
 hist_fincl2 = 'H2OSNO', 'FSNO', 'QRUNOFF', 'QSNOMELT', 'FSNO_EFF', 'SNORDSL', 'SNOW', 'FSDS', 'FSR', 'FLDS', 'FIRE', 'FIRA'
 hist_mfilt = 1,365
 hist_nhtfrq = 0,-24
 hist_avgflag_pertape = 'A','A'
EOF

cat << EOF >> user_nl_mosart
 rtmhist_fincl2 = 'RIVER_DISCHARGE_OVER_LAND_LIQ'
 rtmhist_mfilt = 1,365
 rtmhist_ndens = 2
 rtmhist_nhtfrq = 0,-24
EOF

./case.setup
./case.build
./case.submit

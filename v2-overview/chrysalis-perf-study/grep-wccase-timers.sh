function greptime () {
    grep "CPL:RUN_LOOP\"\|CPL:.*_RUN\|CPL:RUN\"" $1
    grep "PAT_remap\|a:CAM_run*" $1
}

prefix=v2-overview-wccase-chrysalis-r0

for pe in 5 10 XS S M L; do
    for m in $prefix.A_WCYCL1850S_CMIP6.ne30_oECv3 $prefix.WCYCL1850.ne30pg2_EC30to60E2r2; do
        echo $m.$pe
        if [[ ! -d $m.$pe ]]; then
            continue
        fi
        (cd $m.$pe
         t=`find . -name model_timing_stats`
         if [[ "$t" != "" ]]; then
             greptime $t
         fi)
    done
done

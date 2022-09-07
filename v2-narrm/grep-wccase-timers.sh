function greptime () {
    grep "CPL:RUN_LOOP\"\|CPL:.*_RUN\|CPL:RUN\"" $1
    grep "PAT_remap\|a:CAM_run*" $1
}

prefix=chrysalis-perf-study/v2-narrm-wccase-chrysalis-r1-timers/v2-narrm-wccase-chrysalis-r1

for pe in T XS S M L; do
    for m in $prefix.WCYCL20TR.ne30pg2_EC30to60E2r2 $prefix.WCYCL20TR.northamericax4v1pg2_WC14to60E2r3; do
        fname=$m.$pe-model_timing_stats
        if [[ ! -e $fname ]]; then
            continue
        fi
        echo $fname
        greptime $fname
    done
done

function greptime () {
    grep "CPL:RUN_LOOP\"\|CPL:.*_RUN" $1
    grep "PAT_remap\|a:CAM_run*" $1
}

prefix=v2-overview-fcase-chrysalis-r0

for nc in 5 10 20 38 43 45 49 51 57 59 68 70 85; do
    for m in $prefix.FC5AV1C-L.ne30_ne30 $prefix.F2010-CICE.ne30pg2_ne30pg2; do
        echo $m.$nc
        (cd $m.$nc
         t=`find . -name model_timing_stats`
         if [[ "$t" != "" ]]; then
             greptime $t
         fi)
    done
done

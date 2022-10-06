North America RRM coupled-model performance study:

runperf.sh is the run script.

Full timer data are in chrysalis-perf-study/v2-narrm-wccase-chrysalis-r1-timers.

grep-wccase-timers.sh produces the summary file
    chrysalis-perf-study/v2-narrm-wccase-chrysalis-r1-timers.txt 

figs/figs.hy produces the figures. We used
    hy 0.20.0 using CPython(default) 3.8.6 on Linux
Run
    hy figs.hy parse-and-plot-wccase
to produce NARRM-performance-summary.{pdf,png}. Run
    hy figs.hy parse-and-plot-rrm-details
to produce NARRM-performance-model.{pdf,png}.

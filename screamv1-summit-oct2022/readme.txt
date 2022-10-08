The code version used for this data collection is
    https://github.com/E3SM-Project/scream/releases/tag/archive/screamv1-summit-oct2022

run.sh is the run script. It takes one argument, the number of Summit nodes.

get-timer-summary-files.sh collects the timer summary files and copies them to
data/. Additional data are available at
    https://pace.ornl.gov/search/scream-v1-scaling2

figs.hy parses the timer files and makes figures. We run figs.hy with
    hy 0.20.0 using CPython(main) 3.9.12 on Linux

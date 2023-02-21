The code version used for this data collection is
    https://github.com/E3SM-Project/scream/releases/tag/archive/screamv1-summit-oct2022

run.sh is the run script. It takes one argument, the number of Summit nodes.

get-timer-summary-files.sh collects the timer summary files and copies them to
data/. Additional data are available at
    https://pace.ornl.gov/search/scream-v1-scaling2

There are three series of runs. They differ in how LND is parallelized:

    1. 1 rank per resource set:
    ./xmlchange NTASKS=$(($pernode * $nnodes))
    ./xmlchange MAX_TASKS_PER_NODE=6
    ./xmlchange MAX_MPITASKS_PER_NODE=6

    2. 1 rank per resource set, with threads:
    ./xmlchange NTASKS=$(($pernode * $nnodes))
    ./xmlchange MAX_TASKS_PER_NODE=84
    ./xmlchange MAX_MPITASKS_PER_NODE=6
    ./xmlchange LND_NTHRDS=14

    3. 7 ranks per resource set:
    ./xmlchange NTASKS=$(($pernode * $nnodes))
    ./xmlchange PSTRID=7
    ./xmlchange MAX_TASKS_PER_NODE=42
    ./xmlchange MAX_MPITASKS_PER_NODE=42
    ./xmlchange LND_NTASKS=$((42 * $nnodes))
    ./xmlchange LND_PSTRID=1

Series 2 is used in the figures.

figs.hy parses the timer files and makes figures. We run figs.hy with
    hy 0.20.0 using CPython(main) 3.9.12 on Linux

The figures use the following subset of the data:
  scream-v1-scaling2-nnodes1024.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495303.221008-023937-model_timing_stats
  scream-v1-scaling2-nnodes2048.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495304.221009-093803-model_timing_stats
  scream-v1-scaling2-nnodes3072.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495590.221008-072336-model_timing_stats
  scream-v1-scaling2-nnodes4096.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2497059.221010-173053-model_timing_stats
  scream-v1-scaling2-nnodes4608.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495935.221009-090433-model_timing_stats

This directory contains data and code for the Frontier window 10-20 Feb 2023,
plus later additional Frontier runs.

The run*sh scripts are one-off run scripts. They take as an argument the number
of nodes to run on. run-rocm54.sh and run-rocm54-eul.sh use the tag
    https://github.com/E3SM-Project/scream/releases/tag/archive%2Fscreamv1-frontier-feb2023
run-rocm51.sh uses the tag
    https://github.com/E3SM-Project/scream/releases/tag/archive%2Fscreamv1-frontier-feb2023-rocm51
The rocm/5.4, cce/15.0.0 configuration has issues with BLAS in the LND
component. The rocm/5.1, cce/14.0.2 configuration seems fine. As a result, our
figures use the rocm51-annotated data. Later, we were able to redo the
large-scale simulations. These use the branch
    https://github.com/E3SM-Project/scream/tree/sarats/frontier-gb which is
essentially the same rocm/5.1 configuration. These are the
frontier-v1-scream-gb-o3-ne1024 data sets.

jobmonitor.py is a tool to monitor a single job. If e3sm.exe terminates but the
job hangs, jobmonitor.py will kill it, thus minimizing hanging time.

try-until-success.sh is a tool to monitor a single run type, defined by a node
count and a tag to filter the job in the squeue command. It launches a job, then
launches jobmonitor.py for it. Once the job terminates, it checks for a
timer*.gz file. If one is present, it exits. If one is not, it resubmits the
case.

build-and-run-try-until-success.sh is an example of how to build and run a
note-count sweep. It calls all the previously described scripts. You can study
build-and-run-try-until-success.sh to understand how the other scripts are used.

The data/ directory contains model_timing_stats files for a number of runs.

The figs/ directory contains hy (version 0.20 running on any python3) code to
summarize and plot the data.

The figures use the following subset of the data:
  Frontier:
    frontier-v1-scaling1-rocm51-nnodes512.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.1271946.230210-212030-model_timing_stats
    frontier-v1-scaling1-rocm51-nnodes1024.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.1273705.230216-000516-model_timing_stats
    frontier-v1-scaling1-rocm51-nnodes2048.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.1273525.230215-230716-model_timing_stats
    frontier-v1-scream-gb-o3-ne1024-nnodes4096.ne1024pg2_ne1024pg2.F2010-SCREAMv1-1389464.230729-022636-model_timing_stats
    frontier-v1-scream-gb-o3-ne1024-nnodes8192.ne1024pg2_ne1024pg2.F2010-SCREAMv1-1389460.230730-003528-model_timing_stats
  Summit:
    screamv1-summit-oct2022/data/scream-v1-scaling2-nnodes1024.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495303.221008-023937-model_timing_stats
    screamv1-summit-oct2022/data/scream-v1-scaling2-nnodes2048.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495304.221009-093803-model_timing_stats
    screamv1-summit-oct2022/data/scream-v1-scaling2-nnodes3072.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495590.221008-072336-model_timing_stats
    screamv1-summit-oct2022/data/scream-v1-scaling2-nnodes4096.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2497059.221010-173053-model_timing_stats
    screamv1-summit-oct2022/data/scream-v1-scaling2-nnodes4608.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.2495935.221009-090433-model_timing_stats
  Perlmutter CPU
    screamv1-pm-cpu-mar2023/data/pm-cpu-v1-scaling1-nnodes1536.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.6746630.230401-112731-model_timing_stats
    screamv1-pm-cpu-mar2023/data/pm-cpu-v1-scaling1-nnodes2048.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.6907074.230404-030231-model_timing_stats
  Perlmutter GPU
    screamv1-pm-gpu-mar2023/data/pm-gpu-v1-scaling1-nnodes384.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.8132452.230425-101318-model_timing_stats
    screamv1-pm-gpu-mar2023/data/pm-gpu-v1-scaling1-nnodes512.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.5993462.230309-205142-model_timing_stats
    screamv1-pm-gpu-mar2023/data/pm-gpu-v1-scaling1-nnodes1024.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.8421021.230505-110231-model_timing_stats
    screamv1-pm-gpu-mar2023/data/pm-gpu-v1-scaling1-nnodes1536.ne1024pg2_ne1024pg2.F2010-SCREAMv1-timing.8168038.230430-014707-model_timing_stats

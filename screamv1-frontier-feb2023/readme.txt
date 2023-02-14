This directory contains data and code for the Frontier window 10-20 Feb 2023.

The run*sh scripts are one-off run scripts. They take as an argument the number
of nodes to run on. run-rocm54.sh and run-rocm54-eul.sh produce the data used in
the final results. These use the tag
    https://github.com/E3SM-Project/scream/releases/tag/archive%2Fscreamv1-frontier-feb2023

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

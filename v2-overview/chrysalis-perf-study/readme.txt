F-case study:

runf.sh is the run script. See the comments in the file for details.

walltime.py is a utility that runf.sh uses to estimate a job walltime.

untar-fcase-timers.sh and grep-fcase-timers.sh collects summary data from the
E3SM timers and in particular the model_timing_stats files. The output of
grep-timers.sh is recorded in the timers*.txt files.

fcase-timers0.txt: First run. The model_timing_stats files are not recorded
because we don't use these data; the case names were not unique for easy
retrieval from PACE in the future.

fcase-timers1.txt: Second run, done because we wanted a uniquifying prefix for
use in PACE. We use these data in the paper.
  The model_timing_stats files are saved in the directory
    v2-overview-fcase-chrysalis-r0-timers
The PACE dataset corresponding to this run is at the URL
    https://pace.ornl.gov/search/v2-overview-fcase-chrysalis-r0
with PACE IDs
    84695 84680 84693 84688 84713 84691 84710 84694 84698 84682 84701 84685
    84707 84686 84712 84700 84692 84689 84709 84681 84699 84683 84697 84664
    84661 84658 84669 84660
Many files in addition to model_timing_stats are available for each run.

Procedure.
  1. Run v2op.py to enumerate node counts good for GLL physics points, pg2
physics points, and the dycore element decomposition. Choose a representative
subset of these.
  2. Build and submit the jobs:
    for nc in 5 10 20 29 38 43 45 49 51 57 59 68 70 85; do
        for b in v2p0p0 maint1p0; do
            bash runf.sh $b $nc
        done
    done
  3. Use untar-fcase-timers.sh and grep-fcase-timers.sh to make
     fcase-timers1.txt.
  4. Make plots using figs/fig.hy.

WC-case study:

runwc.sh is the script.

wccase-timers1.txt: The model_timing_stats files are saved in the directory
    v2-overview-wccase-chrysalis-r0-timers
The PACE dataset corresponding to this run is at the URL
    https://pace.ornl.gov/search/v2-overview-wccase-chrysalis-r0
with PACE IDs
    84735 84718 84721 84714 84719 84733 84851 84854 84852 84856 84853 

Procedure.
  1. Build and submit the jobs:
    for pe in S M L; do
        for b in maint1p0 v2p0p0; do
            bash runwc.sh $b $pe
        done
    done
  2. Use untar-wccase-timers.sh and grep-wccase-timers.sh to make
     wccase-timers1.txt.

I/O Performance:

io_perf.py: A utility script to parse the I/O performance summary
files (io_perf_summary*.json) and output the average I/O write 
throughputs for the different PE layouts. The script parses and
outputs the I/O write throughputs for the F-case and WC-case
studies mentioned above

io_perf_out.txt: This text file contains the output from io_perf.py
with some extra information obtained from PACE that was used for
the I/O performance evaluation of the F and WC cases.

Procedure.
 1. The I/O output summary files from the F and WC case experiments
    are available in the repository (look for io_perf_summary*.json).
    To calculate the average I/O throughput for the above cases run
    the io_perf.py script.
    
    cd v2-overview/chrysalis-perf-study
    python io_perf.py

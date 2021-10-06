runf.sh is the run script. See the comments in the file for details.

walltime.py is a utility that runf.sh uses to estimate a job walltime.

untar-timers.sh and grep-timers.sh collects summary data from the E3SM timers
and in particular the model_timing_stats files. The output of grep-timers.sh is
recorded in the timers*.txt files.

timers0.txt: First run. The model_timing_stats files are not recorded because we
don't use these data; the case names were not unique for easy retrieval from
PACE in the future.

timers1.txt: Second run, done because we wanted a uniquifying prefix for use in
PACE. We use these data in the paper.
  The model_timing_stats files are saved in the directory
    v2-overview-fcase-chrysalis-r0-timers
The PACE dataset corresponding to this run is at the URL
    https://pace.ornl.gov/search/v2-overview-fcase-chrysalis-r0
with PACE IDs
    84695 84680 84693 84688 84713 84691 84710 84694 84698 84682 84701 84685
    84707 84686 84712 84700 84692 84689 84709 84681 84699 84683 84697 84664
    84661 84658 84669 84660
Many files in addition to model_timing_stats are available for each run.

The procedure was as follows:
  1. Run v2op.py to enumerate node counts good for GLL physics points, pg2
physics points, and the dycore element decomposition. Choose a representative
subset of these.
  2. Build and submit the jobs:
    for nc in 5 10 20 29 38 43 45 49 51 57 59 68 70 85; do
        for b in v2p0p0 maint1p0; do
            bash runf.sh $b $nc
        done
    done
  3. Use untar-timers.sh and grep-timers.sh to produces timers1.txt.
  4. Produces plots using fig.hy.

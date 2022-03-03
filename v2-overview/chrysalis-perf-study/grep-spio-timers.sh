#!/bin/bash
# Get upper bound on the wallclock time to write the data
# - Add the max values from the model_timing_stats for write funcs
# $1 => model_timing_stats file name
function get_ub_wr_wtime () {
  wtime_total=0.0

  if (( $(echo "$wtime_total <= 0.0" |bc -l) )); then
    wtime_total_lnd_river_ice=0.0
    wtime_total_lnd=`grep -i "^\"l.*:PIO.*$" $1 | grep "createfile\|put_var\|write_darray\|sync\|closefile" | awk '{s+=$6} END {printf "%f", s}'`
    wtime_total_river=`grep -i "^\"r.*:PIO.*$" $1 | grep "createfile\|put_var\|write_darray\|sync\|closefile" | awk '{s+=$6} END {printf "%f", s}'`
    wtime_total_lnd_river=`echo "$wtime_total_lnd + $wtime_total_river" | bc`

    wtime_total_ice=`grep -i "^\"i.*:PIO.*$" $1 | grep "createfile\|put_var\|write_darray\|sync\|closefile" | awk '{s+=$6} END {printf "%f", s}'`
    if (( $(echo "$wtime_total_lnd_river > $wtime_total_ice" |bc -l) )); then
      wtime_total_lnd_river_ice=$wtime_total_lnd_river
      component_name="LND+RIVER"
    else
      wtime_total_lnd_river_ice=$wtime_total_ice
      component_name="ICE"
    fi

    echo "DEBUG: LND+RIVER, write time = $wtime_total_lnd_river s" >&2
    echo "DEBUG: ICE, write time = $wtime_total_ice s" >&2
    echo "DEBUG: ((LND+RIVER) | ICE), write time = $wtime_total_lnd_river_ice s" >&2

    wtime_total_atm=`grep -i "^\"a.*:PIO.*$" $1 | grep "createfile\|put_var\|write_darray\|sync\|closefile" | awk '{s+=$6} END {printf "%f", s}'`
    wtime_total_cpl=`grep -i "^\"PIO.*$" $1 | grep "createfile\|put_var\|write_darray\|sync\|closefile" | awk '{s+=$6} END {printf "%f", s}'`

    wtime_total_conc_comp1=`echo "$wtime_total_atm + $wtime_total_cpl + $wtime_total_lnd_river_ice" | bc`

    wtime_total=$wtime_total_conc_comp1
    component_name="(ATM+CPL+ ($component_name))"

    echo "DEBUG: (ATM+CPL+ ((LND+RIVER) | ICE)), write time = $wtime_total_conc_comp1 s" >&2

    wtime_total_ocn=`grep -i "^\"o.*:PIO.*$" $1 | grep "createfile\|put_var\|write_darray\|sync\|closefile" | awk '{s+=$6} END {printf "%f", s}'`
    if (( $(echo "$wtime_total_ocn > $wtime_total" |bc -l) )); then
      wtime_total=$wtime_total_ocn
      component_name="OCN"
    fi

    echo "DEBUG: OCN, write time = $wtime_total_ocn s" >&2

    echo "DEBUG: $component_name : write_time (MAX) = $wtime_total s" >&2
  fi

  echo $wtime_total
}

# Get upper bound on the wallclock time to read the data
# - Add the max values from the model_timing_stats for write funcs
# $1 => model_timing_stats file name
function get_ub_rd_wtime () {
# WARNING: There are no timers in SCORPIO CLASSIC for get_att, hence ignoring (usually too small, < 1s) get_att times for fair comparisons
# with SCORPIO
#  rtime_total=`grep -i "pio" $1 | grep "get_var\|get_att\|read_darray" $1 | awk '{s+=$6} END {printf "%f", s}'`

  rtime_total=0.0

  if (( $(echo "$rtime_total <= 0.0" |bc -l) )); then
    rtime_total_lnd_river_ice=0.0
    rtime_total_lnd=`grep -i "^\"l.*:PIO.*$" $1 | grep "openfile\|get_var\|read_darray" | awk '{s+=$6} END {printf "%f", s}'`
    rtime_total_river=`grep -i "^\"r.*:PIO.*$" $1 | grep "openfile\|get_var\|read_darray" | awk '{s+=$6} END {printf "%f", s}'`
    rtime_total_lnd_river=`echo "$rtime_total_lnd + $rtime_total_river" | bc`

    rtime_total_ice=`grep -i "^\"i.*:PIO.*$" $1 | grep "openfile\|get_var\|read_darray" | awk '{s+=$6} END {printf "%f", s}'`
    if (( $(echo "$rtime_total_lnd_river > $rtime_total_ice" |bc -l) )); then
      rtime_total_lnd_river_ice=$rtime_total_lnd_river
      component_name="LND+RIVER"
    else
      rtime_total_lnd_river_ice=$rtime_total_ice
      component_name="ICE"
    fi

    echo "DEBUG: LND+RIVER, read time = $rtime_total_lnd_river s" >&2
    echo "DEBUG: ICE, read time = $rtime_total_ice s" >&2
    echo "DEBUG: ((LND+RIVER) | ICE), read time = $rtime_total_lnd_river_ice s" >&2

    rtime_total_atm=`grep -i "^\"a.*:PIO.*$" $1 | grep "openfile\|get_var\|read_darray" | awk '{s+=$6} END {printf "%f", s}'`
    #rtime_total_cpl=`grep -i "^PIO:PIOc.*$\|^\"PIO:.*$" $1| grep "openfile\|get_var\|read_darray" | awk '{s+=$6} END {printf "%f", s}'`
    rtime_total_cpl=`grep -i "^\"PIO:.*$" $1| grep "openfile\|get_var\|read_darray" | awk '{s+=$6} END {printf "%f", s}'`

    rtime_total_conc_comp1=`echo "$rtime_total_atm + $rtime_total_cpl + $rtime_total_lnd_river_ice" | bc`

    rtime_total=$rtime_total_conc_comp1
    component_name="(ATM+CPL+ ($component_name))"

    echo "DEBUG: (ATM+CPL+ ((LND+RIVER) | ICE)), read time = $rtime_total_conc_comp1 s" >&2

    rtime_total_ocn=`grep -i "^\"o.*:PIO.*$" $1 | grep "openfile\|get_var\|read_darray" | awk '{s+=$6} END {printf "%f", s}'`
    if (( $(echo "$rtime_total_ocn > $rtime_total" |bc -l) )); then
      rtime_total=$rtime_total_ocn
      component_name="OCN"
    fi

    echo "DEBUG: OCN, read time = $rtime_total_ocn s" >&2

    echo "DEBUG: $component_name : read_time (MAX) = $rtime_total s" >&2
  fi

  echo $rtime_total
}

# Get total size of the *.nc files in the directory
# $1 => run directory name
function get_nc_sz () {
    tot_sz=`ls -lt $1/*.nc | awk '{s+=$5} END {printf "%.0f", s}'`
    echo $tot_sz
}

# Print out the I/O statistics
# $1 => run directory name
# $2 => case name
function get_io_stats() {
  run_dir=$1
  case_name=$2
  latest_stats_file=`find $run_dir -name model_timing_stats -printf '%T@ %p\n' | sort -rn | head -1 | awk '{print $2}'`
  if [[ "$latest_stats_file" != "" ]]; then
    wr_time=$(get_ub_wr_wtime $latest_stats_file)
    rd_time=$(get_ub_rd_wtime $latest_stats_file)
    tot_sz=$(get_nc_sz $run_dir)
    tot_sz=`echo "$tot_sz/(1024 * 1024)" | bc`
    wr_throughput=`echo "$tot_sz/$wr_time" | bc`
    echo "$case_name : write time = $wr_time s : write throughput = $wr_throughput MB/s: read time = $rd_time s: tot_sz = $tot_sz MB"
  else
    echo "ERROR: Timing files not found in $run_dir"
  fi
}

# Default directory prefix to search for timing files
#root_dir=/lcrc/group/e3sm/ac.ambradl/scratch/chrys/v2-overview-wccase-chrysalis-r1-pio.A_WCYCL1850S_CMIP6.ne30_oECv3
root_dir=/lcrc/group/e3sm/jayesh/scratch/chrys/v2-overview-wccase-chrysalis-r1-spio.A_WCYCL1850S_CMIP6.ne30_oECv3

# The script either searches $root_dir.[S|M|L].[1|2]/run for timing files
# OR
# The script searches the run directory specified by the user as the first argument to the script for the timing files
echo "==========================================================="
if [[ "$1" == "" ]]; then
  for pe in S M L; do
    for ver in 1 2; do
      case_dir=$root_dir.$pe.$ver
      run_dir=$case_dir/run
      echo "-----------------------------------------------------------"
      get_io_stats $run_dir $pe.$ver
    done
  done
else
  run_dir=$1
  get_io_stats $run_dir $run_dir
fi
echo "==========================================================="

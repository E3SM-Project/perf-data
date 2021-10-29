import os
import json
import glob
from functools import cmp_to_key

# Compare PE layouts XS, S, M, L and custom layouts represented by number of nodes
def pe_layout_cmp(io_perf1, io_perf2):
  pe1 = io_perf1[0]
  pe2 = io_perf2[0]
  if(pe1.isdigit() and pe2.isdigit()):
    return int(pe1) - int(pe2)
  elif(not pe1.isdigit() and not pe2.isdigit()):
    if pe1 < pe2 :
      return 1
    elif pe1 == pe2:
      return 0
    else:
      return -1
  elif(pe1.isdigit()):
    return 1
  else:
    return -1
  
# Prints out the PE layout (deduced from name of directory containing the I/O performance
# summary files) and the I/O write throughput by reading the I/O performance summary
# files (io_perf_summary*.json) in the JSON format
def print_io_perf(case, compset, res):
  root_dir = case + "-ioperf"
  if not os.path.isdir(root_dir):
    root_dir = "."
  case_dir = case + "." + compset + "." + res + "*"
  search_dir = os.path.join(".", "**", case_dir)
  io_perf = []
  for dname in glob.iglob(search_dir, recursive=True):
    pe_layout = dname.split(".")[-1]
    tot_wb = 0
    times = []
    # Note: Layouts with concurrent components result in one I/O performance summary file
    # per set of concurrent components (all components stacked such that they share the
    # the same root process write out the summary into a single file)
    for fname in glob.iglob(os.path.join(dname, "io_perf_summary*.json")):
      f = open(fname)
      f_data = json.load(f)
      if not "tot_wtime(s)" in f_data["ScorpioIOSummaryStatistics"]["OverallIOStatistics"]:
        # Old version of I/O perf stats - need to calculate write times from throughput and bytes written out
        f_wb = int(f_data["ScorpioIOSummaryStatistics"]["OverallIOStatistics"]["tot_wb"])
        # avg_wtput is in MB/s
        times.append((f_wb)/(1024 * 1024 * float(f_data["ScorpioIOSummaryStatistics"]["OverallIOStatistics"]["avg_wtput"])))
        tot_wb += f_wb
      else:
        # New version of I/O perf stats
        tot_wb += int(f_data["ScorpioIOSummaryStatistics"]["OverallIOStatistics"]["tot_wb(bytes)"])
        times.append(float(f_data["ScorpioIOSummaryStatistics"]["OverallIOStatistics"]["tot_wtime(s)"]))
      f.close()
    if times:
      if max(times) <= 0.0:
        print("ERROR: Read invalid timings from I/O performance summary files, times = ", times)
      else:
        # tot_wtime(s) => slowest process in a single component
        # max(times) => slowest process among all components (including concurrent components)
        io_perf.append((pe_layout, max(times), tot_wb/(1024 * 1024 * 1024 * max(times))))
  #io_perf.sort(key = lambda x: x[0])
  for pe_layout, max_time, throughput in sorted(io_perf, key=cmp_to_key(pe_layout_cmp)):
    print(pe_layout, "\t", max_time, "s\t", throughput, "GB/s")

# The v1 and v2 cases that we have results for
cases = [
          ("E3SM v1 + A_WCYCL1850S_CMIP6 + ne30_oECv3",
          "v2-overview-wccase-chrysalis-r0",
          "A_WCYCL1850S_CMIP6",
          "ne30_oECv3"),
          ("E3SM v2 + WCYCL1850 + ne30pg2_EC30to60E2r2",
          "v2-overview-wccase-chrysalis-r0",
          "WCYCL1850",
          "ne30pg2_EC30to60E2r2"),
          ("E3SM v1 + FC5AV1C-L + ne30_ne30",
          "v2-overview-fcase-chrysalis-r0",
          "FC5AV1C-L",
          "ne30_ne30"),
          ("E3SM v2 + F2010-CICE + ne30pg2_ne30pg2",
          "v2-overview-fcase-chrysalis-r0",
          "F2010-CICE",
          "ne30pg2_ne30pg2")
        ]

for case in cases:
  print(case[0])
  print("======================================================")
  print_io_perf(case[1], case[2], case[3])


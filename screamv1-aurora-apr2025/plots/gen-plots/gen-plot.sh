#!/bin/sh

# Full Model plot
# python gen-plot.py \
#   --aurora_files=timing-files/aurora_scaling_v6/mpich1024-nnodes512,timing-files/aurora_scaling_v6/mpich1024-nnodes1024,timing-files/aurora_scaling_v6/mpich1024-nnodes2048 \
#   --frontier_files=timing-files/frontier_old/frontier-nnodes512,timing-files/frontier_old/frontier-nnodes1024,timing-files/frontier_old/frontier-nnodes2048,timing-files/frontier_old/frontier-nnodes4096,timing-files/frontier_old/frontier-nnodes8192 \
#   --pm_gpu_files=timing-files/pm-gpu_old/pm-gpu-nnodes384,timing-files/pm-gpu_old/pm-gpu-nnodes512,timing-files/pm-gpu_old/pm-gpu-nnodes1024,timing-files/pm-gpu_old/pm-gpu-nnodes1536 \
#   --pm_cpu_files=timing-files/pm-cpu_old/pm-cpu-nnodes1536,timing-files/pm-cpu_old/pm-cpu-nnodes2048 \
#   --pm_gpu_files=timing-files/pm-gpu_old/pm-gpu-nnodes384,timing-files/pm-gpu_old/pm-gpu-nnodes512,timing-files/pm-gpu_old/pm-gpu-nnodes1024,timing-files/pm-gpu_old/pm-gpu-nnodes1536 \
#   --pm_cpu_files=timing-files/pm-cpu_old/pm-cpu-nnodes1536,timing-files/pm-cpu_old/pm-cpu-nnodes2048 \
#   --plot_type="sdpd" \
#   --timers="CPL:RUN_LOOP","a:EAMxx::run","a:EAMxx::homme::run" \
#   --force_timer_labels="Model","Atmosphere","Dycore" \


  # ,timing-files/aurora_scaling_v7/mpich1024-nnodes4096 \
   #,timing-files/frontier_scaling_v6/nnodes4096 \


# python gen-plot.py \
#   --aurora_files=timing-files/aurora_scaling_v7/mpich1024-nnodes512,timing-files/aurora_scaling_v7/mpich1024-nnodes1024,timing-files/aurora_scaling_v7/mpich1024-nnodes2048,timing-files/aurora_scaling_v7/mpich1024-nnodes4096 \
#   --frontier_files=timing-files/frontier_scaling_v6/nnodes512,timing-files/frontier_scaling_v6/nnodes1024,timing-files/frontier_scaling_v6/nnodes2048,timing-files/frontier_scaling_v6/nnodes4096 \
#   --pm_gpu_files=timing-files/pm-gpu_old/pm-gpu-nnodes384,timing-files/pm-gpu_old/pm-gpu-nnodes512,timing-files/pm-gpu_old/pm-gpu-nnodes1024,timing-files/pm-gpu_old/pm-gpu-nnodes1536 \
#   --pm_cpu_files=timing-files/pm-cpu_old/pm-cpu-nnodes1536,timing-files/pm-cpu_old/pm-cpu-nnodes2048 \
#   --pm_gpu_files=timing-files/pm-gpu_old/pm-gpu-nnodes384,timing-files/pm-gpu_old/pm-gpu-nnodes512,timing-files/pm-gpu_old/pm-gpu-nnodes1024,timing-files/pm-gpu_old/pm-gpu-nnodes1536 \
#   --pm_cpu_files=timing-files/pm-cpu_old/pm-cpu-nnodes1536,timing-files/pm-cpu_old/pm-cpu-nnodes2048 \
#   --plot_type="sdpd" \
#   --timers="a:EAMxx::run" \
#   --force_timer_labels="E3SM Atmosphere" \

#TESTING
python gen-plot.py \
  --aurora_files=timing-files/aurora_scaling_v7/mpich1024-nnodes512,timing-files/aurora_scaling_v7/mpich1024-nnodes1024,timing-files/aurora_scaling_v7/mpich1024-nnodes2048,timing-files/aurora_scaling_v7/mpich1024-nnodes4096 \
  --timers="a:caar_bexchV"+"a:hvf-bexch","a:caar compute"+"a:compute_stage_value_dirk"+"a:compose_transport","a:caar limiter","a:EAMxx::physics::run" \
  --plot_type="sdpd" \
  --force_timer_labels="Dycore-MPI","Dycore-compute (device-only)","Dycore-limiter (device-only)","Physics (device-only)" \
  --frontier_files=timing-files/frontier_scaling_v6/nnodes512,timing-files/frontier_scaling_v6/nnodes1024,timing-files/frontier_scaling_v6/nnodes2048,timing-files/frontier_scaling_v6/nnodes4096 \
  --plot_type="sdpd" \
  #--pm_gpu_files=timing-files/pm-gpu_old/pm-gpu-nnodes384,timing-files/pm-gpu_old/pm-gpu-nnodes512,timing-files/pm-gpu_old/pm-gpu-nnodes1024,timing-files/pm-gpu_old/pm-gpu-nnodes1536 \
  #--pm_cpu_files=timing-files/pm-cpu_old/pm-cpu-nnodes1536,timing-files/pm-cpu_old/pm-cpu-nnodes2048 \

# python gen-plot.py \
#   --aurora_files=timing-files/aurora_scaling_v6/mpich1024-nnodes512,timing-files/aurora_scaling_v6/mpich1024-nnodes1024,timing-files/aurora_scaling_v6/mpich1024-nnodes2048 \
#   --aurora_files2=timing-files/aurora_scaling_v5-noSK/nnodes512,timing-files/aurora_scaling_v5-noSK/nnodes1024,timing-files/aurora_scaling_v5-noSK/nnodes2048 \
#   --timers="a:EAMxx::homme::run","a:caar_bexchV"+"a:hvf-bexch","a:caar compute"+"a:compute_stage_value_dirk"+"a:compose_transport","a:caar limiter","a:EAMxx::physics::run" \
#   --plot_type="sdpd" \
#   --force_machine_labels="Aurora - New","Aurora - Old" \
#   --force_timer_labels="Dycore-total","Dycore-MPI","Dycore-compute","Dycore-limiter","Physics" \

# DYCORE only
# python gen-plot.py \
#   --aurora_files=aurora_scaling_v6/nnodes512,aurora_scaling_v6/nnodes1024,aurora_scaling_v6/nnodes2048 \
#   --aurora_files2=aurora_scaling_v3/aurora-nnodes512,aurora_scaling_v3/aurora-nnodes1024,aurora_scaling_v3/aurora-nnodes2048 \
#   --frontier_files=frontier_old/frontier-nnodes512,frontier_old/frontier-nnodes1024,frontier_old/frontier-nnodes2048,frontier_old/frontier-nnodes4096,frontier_old/frontier-nnodes8192 \
#   --pm_gpu_files=pm-gpu_old/pm-gpu-nnodes384,pm-gpu_old/pm-gpu-nnodes512,pm-gpu_old/pm-gpu-nnodes1024,pm-gpu_old/pm-gpu-nnodes1536 \
#   --pm_cpu_files=pm-cpu_old/pm-cpu-nnodes1536,pm-cpu_old/pm-cpu-nnodes2048 \
#   --timers="a:EAMxx::homme::run" \
#   --no_title=True \
#   --plot_type=sypd

# Full model plot 2
# python gen-plot.py \
#   --aurora_files=aurora_scaling_v5-noSK/aurora-nnodes512,aurora_scaling_v5-noSK/aurora-nnodes1024,aurora_scaling_v5-noSK/aurora-nnodes2048 \
#   --frontier_files=frontier_new/frontier-nnodes512,frontier_new/frontier-nnodes1024,frontier_new/frontier-nnodes2048 \
#   --timers="CPL:RUN_LOOP","a:EAMxx::physics::run","a:EAMxx::homme::run" \
#   --no_title=True \
#   --plot_type=sypd \

# Dycore comp plot
# python gen-plot.py \
#   --aurora_files=timing-files/aurora_scaling_v6/mpich1024-nnodes512,timing-files/aurora_scaling_v6/mpich1024-nnodes1024,timing-files/aurora_scaling_v6/mpich1024-nnodes2048 \
#   --timers="a:EAMxx::homme::run","a:caar_bexchV","a:hvf-bhwk","a:hvf-bexch" \
#   --plot_type=sypd \
#   --frontier_files=timing-files/frontier_scaling_v6/nnodes512,timing-files/frontier_scaling_v6/nnodes1024,timing-files/frontier_scaling_v6/nnodes2048 \
#  --aurora_files2=aurora_scaling_v6/mpich1024-nnodes512,aurora_scaling_v6/mpich1024-nnodes1024,aurora_scaling_v6/mpich1024-nnodes2048 \
#   --timers="a:EAMxx::homme::run","a:caar compute","a:caar_bexchV","a:compute_stage_value_dirk","a:caar limiter","a:tl-ae advance_hypervis_dp","a:tl-at prim_advec_tracers_compose","a:hvf-bhwk","a:hvf-bexch" \

# Efficiency plot
# python gen-plot.py \
#   --aurora_files=aurora_scaling_v5-noSK/aurora-nnodes256,aurora_scaling_v5-noSK/aurora-nnodes512,aurora_scaling_v5-noSK/aurora-nnodes1024,aurora_scaling_v5-noSK/aurora-nnodes2048 \
#   --frontier_files=frontier_new/frontier-nnodes256,frontier_new/frontier-nnodes512,frontier_new/frontier-nnodes1024,frontier_new/frontier-nnodes2048 \
#   --timers="a:EAMxx::homme::run","a:EAMxx::physics::run" \
#   --no_title=True \
#   --plot_type=eff


# NE30 test
# python gen-plot.py \
#   --aurora_files=aurora_scaling_v6/nnodes1,aurora_scaling_v6/nnodes4 \
#   --frontier_files=frontier_scaling_v4/frontier-nnodes1,frontier_scaling_v4/frontier-nnodes2,frontier_scaling_v4/frontier-nnodes4 \
#   --timers="a:EAMxx::physics::run","a:caar compute","a:caar_bexchV","a:compute_stage_value_dirk" \
#   --no_title=True \
#   --plot_type=time

  # phys: [34.128, 27.669, 24.698]

# python gen-plot.py \
#   --aurora_files=aurora_scaling_v4-noSK/aurora-nnodes1,aurora_scaling_v4-noSK/aurora-nnodes2,aurora_scaling_v4-noSK/aurora-nnodes4 \
#   --frontier_files=frontier_scaling_v4/frontier-nnodes1,frontier_scaling_v4/frontier-nnodes2,frontier_scaling_v4/frontier-nnodes4 \
#   --timers="a:EAMxx::physics::run","a:caar compute","a:caar_bexchV","a:compute_stage_value_dirk" \
#   --no_title=True \
#   --plot_type=sypd

# python gen-plot.py \
#   --aurora_files=aurora_scaling_v5/aurora-nnodes512,aurora_scaling_v5/aurora-nnodes1024,aurora_scaling_v5/aurora-nnodes2048 \
#   --timers="CPL:RUN_LOOP","a:EAMxx::physics::run","a:EAMxx::homme::run" \
#   --no_title=True \
#   --plot_type=sypd \
#   --aurora_files2=aurora_scaling_v5-noSK/aurora-nnodes512,aurora_scaling_v5-noSK/aurora-nnodes1024,aurora_scaling_v5-noSK/aurora-nnodes2048 \
#   --frontier_files=frontier_old/frontier-nnodes512,frontier_old/frontier-nnodes1024,frontier_old/frontier-nnodes2048 \

  # phys: [33.061, 23.083, 19.831]
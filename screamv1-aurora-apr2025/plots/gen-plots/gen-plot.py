import argparse
import sys
from impl.data_manager import extract_data,convert_to_sypd,convert_to_sdpd
from impl.plot_data import plot_data


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot Simulated Days per Wallclock Day (SYPD) for timing data.")
    parser.add_argument("--aurora_files", required=False, help="Comma-separated list of input files containing Aurora timing data.")
    parser.add_argument("--aurora_files2", required=False, help="Comma-separated list of input files containing Aurora timing data.")
    parser.add_argument("--frontier_files", required=False, help="Comma-separated list of input files containing Frontier timing data.")
    parser.add_argument("--pm_gpu_files", required=False, help="Comma-separated list of input files containing PM-GPU timing data.")
    parser.add_argument("--pm_cpu_files", required=False, help="Comma-separated list of input files containing PM-CPU timing data.")
    parser.add_argument("--timers", required=True, help="Comma-separated list of timer names to plot.")
    parser.add_argument("--timing_column", type=str, default="wallmax", help="Name of column to select timing data from.")
    parser.add_argument("--plot_type", type=str, choices=["sypd", "sdpd", "time"], default="sypd", help="Y-axis on plot. Default is \"sypd\".")
    parser.add_argument("--simulation_length_in_days", type=float, default=0.5, help="Length of the simulation in days. Default is 0.5.")
    parser.add_argument("--no_title", type=bool, default=False, help="Delete title from plot. Default is False.")
    args = parser.parse_args()

    if not args.aurora_files and args.aurora_files2 and not args.frontier_files:
        print(f"No data files passed.")
        sys.exit(1)

    aurora_files = args.aurora_files.split(",") if args.aurora_files else []
    aurora_files2 = args.aurora_files2.split(",") if args.aurora_files2 else []
    frontier_files = args.frontier_files.split(",") if args.frontier_files else []
    pm_gpu_files = args.pm_gpu_files.split(",") if args.pm_gpu_files else []
    pm_cpu_files = args.pm_cpu_files.split(",") if args.pm_cpu_files else []
    timers = args.timers.split(",")
    timing_col = args.timing_column
    plot_type = args.plot_type
    simulation_length_in_days = args.simulation_length_in_days
    no_title = args.no_title

    # Initialize timer data structure
    aurora_timer_data = {timer: {"nodes": [], "values": []} for timer in timers}
    aurora_timer_data2 = {timer: {"nodes": [], "values": []} for timer in timers}
    frontier_timer_data = {timer: {"nodes": [], "values": []} for timer in timers}
    pm_gpu_timer_data = {timer: {"nodes": [], "values": []} for timer in timers}
    pm_cpu_timer_data = {timer: {"nodes": [], "values": []} for timer in timers}

    # Process Aurora files
    for file_path in aurora_files:
        for timer in timers:
            data = extract_data(file_path, timer, 12, timing_col)
            if data is None:
                sys.exit(1)
            aurora_timer_data[timer]["nodes"].append(data[0])
            aurora_timer_data[timer]["values"].append(data[1])

    # Process Aurora files2
    for file_path in aurora_files2:
        for timer in timers:
            data = extract_data(file_path, timer, 12, timing_col)
            if data is None:
                sys.exit(1)
            aurora_timer_data2[timer]["nodes"].append(data[0])
            aurora_timer_data2[timer]["values"].append(data[1])

    # Process Frontier files
    for file_path in frontier_files:
        for timer in timers:
            data = extract_data(file_path, timer, 8, timing_col)
            if data is None:
                sys.exit(1)
            frontier_timer_data[timer]["nodes"].append(data[0])
            frontier_timer_data[timer]["values"].append(data[1])

    # Process PM-GPU files
    for file_path in pm_gpu_files:
        for timer in timers:
            data = extract_data(file_path, timer, 4, timing_col)
            if data is None:
                sys.exit(1)
            pm_gpu_timer_data[timer]["nodes"].append(data[0])
            pm_gpu_timer_data[timer]["values"].append(data[1])

    # Process PM-CPU files
    for file_path in pm_cpu_files:
        for timer in timers:
            data = extract_data(file_path, timer, 128, timing_col)
            if data is None:
                sys.exit(1)
            pm_cpu_timer_data[timer]["nodes"].append(data[0])
            pm_cpu_timer_data[timer]["values"].append(data[1])

    # Convert data to SYPD or efficiency if needed
    if plot_type == "time":
        aurora_dat = aurora_timer_data
        aurora_dat2 = aurora_timer_data2
        frontier_dat = frontier_timer_data
        pm_gpu_dat = pm_gpu_timer_data
        pm_cpu_dat = pm_cpu_timer_data
    elif plot_type == "sypd":
        aurora_dat = convert_to_sypd(aurora_timer_data, simulation_length_in_days)
        aurora_dat2 = convert_to_sypd(aurora_timer_data2, simulation_length_in_days)
        frontier_dat = convert_to_sypd(frontier_timer_data, simulation_length_in_days)
        pm_gpu_dat = convert_to_sypd(pm_gpu_timer_data, 2*simulation_length_in_days) #PM sims are longer
        pm_cpu_dat = convert_to_sypd(pm_cpu_timer_data, 2*simulation_length_in_days)
    elif plot_type == "sdpd":
        aurora_dat = convert_to_sdpd(aurora_timer_data, simulation_length_in_days)
        aurora_dat2 = convert_to_sdpd(aurora_timer_data2, simulation_length_in_days)
        frontier_dat = convert_to_sdpd(frontier_timer_data, simulation_length_in_days)
        pm_gpu_dat = convert_to_sdpd(pm_gpu_timer_data, 2*simulation_length_in_days) #PM sims are longer
        pm_cpu_dat = convert_to_sdpd(pm_cpu_timer_data, 2*simulation_length_in_days)

    # Plot the combined data
    plot_data(aurora_dat, aurora_dat2, frontier_dat, pm_gpu_dat, pm_cpu_dat, plot_type, timing_col, no_title)

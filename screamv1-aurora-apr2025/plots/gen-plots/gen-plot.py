import argparse
import sys
from impl.data_manager import extract_data
from impl.plot_data import plot_data


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot Simulated Days per Wallclock Day (SYPD) for timing data.")
    parser.add_argument("--aurora_files", required=False, help="Comma-separated list of input files containing Aurora timing data.")
    parser.add_argument("--aurora_files2", required=False, help="Comma-separated list of input files containing Aurora timing data.")
    parser.add_argument("--frontier_files", required=False, help="Comma-separated list of input files containing Frontier timing data.")
    parser.add_argument("--pm_gpu_files", required=False, help="Comma-separated list of input files containing PM-GPU timing data.")
    parser.add_argument("--pm_cpu_files", required=False, help="Comma-separated list of input files containing PM-CPU timing data.")
    parser.add_argument("--timers", required=True, help="Comma-separated list of timer names to plot. Timers can be combined by using '+'")
    parser.add_argument("--force_timer_labels", required=False, help="Comma-separated list of timer labels to use.")
    parser.add_argument("--force_machine_labels", required=False, help="Comma-separated list of machine labels to use.")
    parser.add_argument("--timing_column", type=str, default="wallmax", help="Name of column to select timing data from.")
    parser.add_argument("--plot_type", type=str, choices=["sypd", "sdpd", "time"], default="sypd", help="Y-axis on plot. Default is \"sypd\".")
    parser.add_argument("--plot_title", required=False, type=str, help="Plot title.")
    args = parser.parse_args()

    if not args.aurora_files and args.aurora_files2 and not args.frontier_files and not args.pm_gpu_files and not args.pm_cpu_files:
        print(f"No data files passed.")
        sys.exit(1)

    # Initialize parameters
    file_data_array = []

    if args.aurora_files:
        aurora_files = args.aurora_files.split(",")
        file_data_array.append({"files": aurora_files, "timer_data": {}, "procs_per_node": 12, "simulation_length_in_days": 0.5, "label": "Aurora [Intel GPU]"})

    if args.aurora_files2:
        aurora_files2 = args.aurora_files2.split(",")
        file_data_array.append({"files": aurora_files2, "timer_data": {}, "procs_per_node": 12, "simulation_length_in_days": 0.5, "label": "Aurora2 [Intel GPU]"})

    if args.frontier_files:
        frontier_files = args.frontier_files.split(",")
        file_data_array.append({"files": frontier_files, "timer_data": {}, "procs_per_node": 8, "simulation_length_in_days": 0.5, "label": "Frontier [AMD GPU]"})

    if args.pm_gpu_files:
        pm_gpu_files = args.pm_gpu_files.split(",")
        file_data_array.append({"files": pm_gpu_files, "timer_data": {}, "procs_per_node": 4, "simulation_length_in_days": 1, "label": "Permutter [NVIDIA GPU]"})

    if args.pm_cpu_files:
        pm_cpu_files = args.pm_cpu_files.split(",")
        file_data_array.append({"files": pm_cpu_files, "timer_data": {}, "procs_per_node": 128, "simulation_length_in_days": 1, "label": "Perlmutter [AMD CPU]"})

    if len(file_data_array)>4:
        print(f"Error! Currently script only supports up to 4 machines.")
        sys.exit(1)

    timers = args.timers.split(",")
    force_timer_labels = args.force_timer_labels.split(",") if args.force_timer_labels else []
    force_machine_labels = args.force_machine_labels.split(",") if args.force_machine_labels else []
    timing_col = args.timing_column
    plot_type = args.plot_type
    plot_title = args.plot_title

    # Add naming map for some timers
    timer_to_label_dict = {
        "CPL:RUN_LOOP": "Full Model",
        "CPL:ATM_RUN": "Atmosphere",
        "a:EAMxx::homme::run": "Dycore",
        "a:EAMxx::physics::run": "Physics"
    }
    if len(force_timer_labels)>0:
        if len(force_timer_labels)!=len(timers):
            print(f"Error! The number of timer labels must match the number of timers.")
            sys.exit(1)
        for i in range(len(force_timer_labels)):
            timer_to_label_dict[timers[i]] = force_timer_labels[i]

    if len(force_machine_labels)>0:
        if len(force_machine_labels)!=len(file_data_array):
            print(f"Error! The number of machine labels must match the number of machines.")
            sys.exit(1)
        for i in range(len(file_data_array)):
            file_data_array[i]["label"] = force_machine_labels[i]

    # Initialize timer data structures
    for entry in file_data_array:
        entry["timer_data"] = {timer_to_label_dict.get(timer,timer): {"nodes": [], "values": []} for timer in timers}

    # Process files dynamically
    for entry in file_data_array:
        machine = entry["label"]
        for file_path in entry["files"]:
            for timer in timers:
                data = extract_data(file_path,timer,entry["procs_per_node"],timing_col,
                                    entry["simulation_length_in_days"],plot_type,entry["label"])
                if data is None:
                    print(f"extract_data() failed. Machine: {machine}, file_path: {file_path}, timer: {timer}.")
                    sys.exit(1)
                timer_nickname = timer_to_label_dict.get(timer,timer)
                entry["timer_data"][timer_nickname]["nodes"].append(data[0])
                entry["timer_data"][timer_nickname]["values"].append(data[1])

    for entry in file_data_array:
        print(f"Label: {entry['label']}")
        print(f"Timer Data: {entry['timer_data']}")

    # Plot the combined data
    plot_data(file_data_array, plot_type, plot_title)

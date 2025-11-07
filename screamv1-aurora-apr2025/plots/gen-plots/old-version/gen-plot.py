import argparse
import sys
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import re
import math
import statistics

def preprocess_line(line):
    # Remove text within parentheses using regex
    cleaned_line = re.sub(r'\s*\(.*?\)', '', line)
    # Split the line by spaces, preserving quoted names
    return re.findall(r'"[^"]*"|\S+', cleaned_line.strip())

def extract_data(file_path, target_name, procs_per_node,timing_col):
    try:
        with open(file_path, 'r') as file:
            # Skip unrelated text until the header line is found
            for line in file:
                if line.strip().startswith("name"):
                    header = line.strip()
                    break
            else:
                print(f"Error: Header line not found in file '{file_path}'.")
                return None

            # Preprocess the header to remove parentheses
            columns = preprocess_line(header)

            # Find the requested timing column and 'processes' column
            timing_col_index = next((i for i, col in enumerate(columns) if col == timing_col), None)
            processes_index = next((i for i, col in enumerate(columns) if col == "processes"), None)

            # Ensure both columns exist
            if timing_col_index is None or processes_index is None:
                print(f"Error: Required columns ('{timing_col}' or 'processes') not found in file '{file_path}'.")
                return None

            # Add double quotes around the target name
            quoted_target_name = f'"{target_name}"'

            # Iterate through the remaining lines to find the target name
            for line in file:
                # Preprocess the data row to remove parentheses
                parts = preprocess_line(line.strip())

                # Check if the line contains the quoted target name
                if parts[0] == quoted_target_name:
                    # Extract the timing_col value and 'processes' value
                    timing_col_value = parts[timing_col_index]
                    processes_value = parts[processes_index]

                    # Clean up the timing_col value to remove any extra parentheses or numbers
                    timing_col_cleaned = timing_col_value.strip()  # No need to split further since parentheses are removed
                    processes_cleaned = int(processes_value.strip())  # Convert processes to integer

                    # Calculate the number of nodes
                    number_of_nodes = processes_cleaned / procs_per_node

                    return [number_of_nodes, float(timing_col_cleaned)]

            # If the name is not found, return None
            print(f"Error: Target name '{target_name}' not found in file '{file_path}'.")
            return None

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        return None
    except Exception as e:
        print(f"Error: An unexpected error occurred - {e}")
        return None

def convert_to_sypd(timer_data, simulation_length_in_days):
    # Convert runtime to simulated days per day
    sypd_data = {}
    for timer, data in timer_data.items():
        sypd_data[timer] = {
            "nodes": data["nodes"],
            "values": [((simulation_length_in_days/365.25)/value)*60*60*24 for value in data["values"]]
        }
    return sypd_data

def convert_to_efficiency(timer_data, nsteps, gpus_per_node):
    # Convert runtime to "thousands of element timesteps per GPU" and
    # convert nodes to "spectral elements per processing unit"
    eff_data = {}
    for time, data in timer_data.items():
        eff_data[time] = {
            "nodes": [6*1024*1024/(node*gpus_per_node) for node in data["nodes"]],
            "values": [1e-3*(6*1024*1024)*nsteps[time]/(node*gpus_per_node)/value for node, value in zip(data["nodes"], data["values"])]
        }
    return eff_data

def plot_data(aurora_timer_data, aurora_timer_data2, frontier_timer_data, pm_gpu_timer_data, pm_cpu_timer_data, plot_type, timing_col, no_title):
    fig, ax = plt.subplots(figsize=(9, 6))

    aurora_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in aurora_timer_data.values())
    aurora2_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in aurora_timer_data2.values())
    frontier_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in frontier_timer_data.values())
    pm_gpu_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in pm_gpu_timer_data.values())
    pm_cpu_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in pm_cpu_timer_data.values())

    #markers = ['o', 'v', 's', 'd', 'x', '*', 'p', 'h', '^']
    #colors = ['r','g','b', 'm', 'y', 'c']
    #colors = ['k', 'r', 'g','b', 'm', 'y', 'c'] # FULL MODEL

    # DYCORE ONLY
    colors = ['g', 'r', 'purple', 'b', 'c', 'y', 'k']
    markers = ['s','o', 'v', 'x', 'd', '*', 'p', 'h', '^']
    markersize_ = 10
    linewidth_ = 3
    ax_label_size = 18
    tick_font_size = 17


    timer_to_label_dict = {
        "CPL:RUN_LOOP": "Model",
        "CPL:ATM_RUN": "Atmosphere",
        "a:EAMxx::homme::run": "Dycore",
        "a:EAMxx::physics::run": "Physics"
    }
    idx=0
    for timer, data in aurora_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        print("AURORA\n",sorted_nodes,sorted_values,"\n")
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='-', label=timer_to_label_dict.get(timer, timer))
        #ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='-',marker=markers[idx], markerfacecolor='none', color=colors[idx], label=timer_to_label_dict.get(timer, timer))
        #ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='-',marker=markers[idx], markersize=markersize_, markerfacecolor='none', color=colors[idx])
        if(not aurora_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in aurora_timer_data2.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        print("AURORA2\n",sorted_nodes,sorted_values,"\n")
        ax.plot(sorted_nodes, sorted_values, linewidth=2,linestyle=':')
        #ax.plot(sorted_nodes, sorted_values, linewidth=2,linestyle=':',marker=markers[idx], markersize=markersize_, markerfacecolor='none', color=colors[idx])
        if(not aurora2_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in frontier_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        print("FRONTIER\n",sorted_nodes,sorted_values,"\n")
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='-.')
        #ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='-.',marker=markers[idx], markersize=markersize_, markerfacecolor='none', color=colors[idx])
        if(not frontier_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in pm_gpu_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        print("PM-GPU\n",sorted_nodes,sorted_values,"\n")
        if len(sorted_values) > 0:
            sorted_values[-2] *=2# HACK because sim is 2x length here
            sorted_values[-1] *=2 # HACK because sim is 2x length here
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle='--',marker=markers[idx], markersize=markersize_, markerfacecolor='none', color=colors[idx])
        if(not pm_gpu_is_empty): idx+=1
    ax.set_prop_cycle(None)
    idx=0
    for timer, data in pm_cpu_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        print("PM-CPU\n",sorted_nodes,sorted_values,"\n")
        ax.plot(sorted_nodes, sorted_values, linewidth=linewidth_,linestyle=':',marker=markers[idx], markersize=markersize_, markerfacecolor='none', color=colors[idx])
        if(not pm_cpu_is_empty): idx+=1

    # Get a legend without aurora/frontier/pm lines
    if plot_type == "sypd" or plot_type=="time": first_legend = ax.legend(loc='lower left', fontsize=9)#fontsize=15)
    elif plot_type=="eff": first_legend = ax.legend(loc='upper right',fontsize=15)

    # Dummy lines for machine
    machine_lines = []
    idx=0
    if not aurora_is_empty:
        aurora_line, = ax.plot([],[],linestyle='-',color=colors[-1],label='Aurora [Intel]', markerfacecolor='none')
        machine_lines.append(aurora_line)
        #idx+=1
    if not aurora2_is_empty:
        aurora_line2, = ax.plot([],[],linestyle='--',color=colors[-1],label='Aurora2',markerfacecolor='none')
        machine_lines.append(aurora_line2)
        #idx+=1
    if not frontier_is_empty:
        frontier_line, = ax.plot([],[],linestyle='-.',color=colors[-1],label='Frontier [AMD]',markerfacecolor='none')
        machine_lines.append(frontier_line)
        #idx+=1
    if not pm_gpu_is_empty:
        pm_gpu_line, = ax.plot([],[],linestyle='--',color=colors[idx],label='Perlmutter-GPU [NVIDIA]',markerfacecolor='none')
        machine_lines.append(pm_gpu_line)
        #idx+=1
    if not pm_cpu_is_empty:
        pm_cpu_line, = ax.plot([],[],linestyle=':',color=colors[idx],label='Perlmutter-CPU [AMD]',markerfacecolor='none')
        machine_lines.append(pm_cpu_line)

    unique_nodes = sorted(set([int(node) for timer_data in [aurora_timer_data, aurora_timer_data2, frontier_timer_data, pm_gpu_timer_data, pm_cpu_timer_data] for timer in timer_data.values() for node in timer["nodes"]]))

    # Calculate "optimal scaling" line
    if plot_type != "eff":
        if not aurora_is_empty:
            first_values = [data["values"][0] for data in aurora_timer_data.values()]  # First data point for each timer
        if not aurora2_is_empty:
            first_values = [data["values"][0] for data in aurora_timer_data2.values()]  # First data point for each timer
        elif not frontier_is_empty:
            first_values = [data["values"][0] for data in frontier_timer_data.values()]  # First data point for each timer
        elif not pm_gpu_is_empty:
            first_values = [data["values"][0] for data in pm_gpu_timer_data.values()]  # First data point for each timer
        #optimal_start = statistics.median(first_values)  # Median of first data points
        #optimal_start = 0.1 #FULL MODEL
        optimal_start = 1
        #optimal_start = 200
        opt_nodes = sorted(set([int(node) for timer_data in [aurora_timer_data, aurora_timer_data2, frontier_timer_data] for timer in timer_data.values() for node in timer["nodes"]]))
        first = opt_nodes[0]
        last = opt_nodes[-1]
        opt_nodes.insert(0, first/2)
        opt_nodes.append(last*2)
        if plot_type=="sypd":
            optimal_values = [optimal_start * (2 ** i) for i in range(len(opt_nodes))]  # Double for each subsequent node

        else:
            optimal_values = [optimal_start / (2 ** i) for i in range(len(opt_nodes))]  # Halve for each subsequent node

        # Plot "optimal scaling" line
        #ax.plot(opt_nodes, optimal_values, linewidth=1,linestyle='-', color='black')

    ax.set_xscale("log")
    if True or plot_type=="sypd" or plot_type=="time": ax.set_yscale("log")
    if plot_type == "eff":
        x_label = "Number of elements per GPU"
    else:
        x_label = "Number of nodes"
    ax.set_xlabel(x_label, fontsize=ax_label_size)
    if plot_type=="time":
        y_label = "Elapsed time (s)"
    elif plot_type == "sypd":
        y_label = "Simulated years per wallclock day (SYPD)"
    elif plot_type == "eff":
        y_label = "Thousands of element time steps per GPU per second"
    ax.set_ylabel(y_label, fontsize=ax_label_size)

    # FULL MODEL OUTPUT
    #yticks = [20,30,40,50,60,70,80,90,100,125,150,175,200,250,300, 350,400,500,600,700]
    #yticks = [30,40,50,60,70,80,90,100,125,150,175,200,250,300, 350,400,500,600,700]
    # yticks = [0.1,0.2,0.3,0.4,0.5,0.6,0.7,1,2]

    # ax.set_ylim(min(yticks)-0.02, max(yticks))
    # ax.set_yticks(yticks)
    # ax.set_yticklabels(yticks, fontsize=tick_font_size)
    # ax.set_xlim(350,9000)

    # FULL MODEL OUTPUT
    #ax.set_xlim(480,2200)

    # ax.set_ylim(25,200)

    # ax.set_xlim(500, 2100)
    # ax.set_ylim(0.1, 10)

    # EFFICIENCY
    #ax.set_ylim(.35, 45)

    # Add legend with aurora frontier pm lines, and add first legend back
    ax.legend(handles=machine_lines, loc='upper left', fontsize=9)#fontsize=15)
    ax.add_artist(first_legend)

    ax.grid(True, which="both", linestyle="--", linewidth=0.5)

    if not no_title:
        if not aurora_is_empty and not frontier_is_empty:
            ax.set_title("Aurora and Frontier Scalaing ("+timing_col+")")
        elif not aurora_is_empty:
            ax.set_title("Aurora Scalaing ("+timing_col+")")
        else:
            ax.set_title("Frontier Scalaing ("+timing_col+")")

    unique_labels = [str(node) for node in unique_nodes]
    ax.set_xticks(unique_nodes)
    ax.set_xticklabels(unique_labels, fontsize=tick_font_size)
    ax.xaxis.minorticks_off()

    plt.show()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot Simulated Days per Wallclock Day (SYPD) for timing data.")
    parser.add_argument("--aurora_files", required=False, help="Comma-separated list of input files containing Aurora timing data.")
    parser.add_argument("--aurora_files2", required=False, help="Comma-separated list of input files containing Aurora timing data.")
    parser.add_argument("--frontier_files", required=False, help="Comma-separated list of input files containing Frontier timing data.")
    parser.add_argument("--pm_gpu_files", required=False, help="Comma-separated list of input files containing PM-GPU timing data.")
    parser.add_argument("--pm_cpu_files", required=False, help="Comma-separated list of input files containing PM-CPU timing data.")
    parser.add_argument("--timers", required=True, help="Comma-separated list of timer names to plot.")
    parser.add_argument("--timing_column", type=str, default="wallmax", help="Name of column to select timing data from.")
    parser.add_argument("--plot_type", type=str, choices=["sypd", "time", "eff"], default="sypd", help="Y-axis on plot. Default is \"sypd\".")
    parser.add_argument("--simulation_length_in_days", type=float, default=0.5, help="Length of the simulation in days. Default is 0.5.")
    parser.add_argument("--no_title", type=bool, default=False, help="Delete title from plot. Default is False.")
    args = parser.parse_args()
    print(args,"\n")

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
                print("BAD ",file_path, timer)
                sys.exit(1)
            else: print ("OK ",file_path, timer)
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

    # If plotting efficiency, get number of timesteps
    nsteps = {}
    if plot_type == "eff":
        for timer in timers:
            nstep = 0
            for file_path in aurora_files:
                count_data = extract_data(file_path, timer, 12, "count")
                count_data[0] *= 12 # extract_data return number of nodes, but we need processes
                if (nstep==0):
                    nstep = round(count_data[1]/count_data[0])
                else:
                    assert nstep == round(count_data[1]/count_data[0]), "Different number of steps for same timer in different files"
            for file_path in aurora_files2:
                count_data = extract_data(file_path, timer, 12, "count")
                count_data[0] *= 12 # extract_data return number of nodes, but we need processes
                if (nstep==0):
                    nstep = round(count_data[1]/count_data[0])
                else:
                    assert nstep == round(count_data[1]/count_data[0]), "Different number of steps for same timer in different files"
            for file_path in frontier_files:
                count_data = extract_data(file_path, timer, 8, "count")
                count_data[0] *= 8 # extract_data return number of nodes, but we need processes
                if (nstep==0):
                    nstep = round(count_data[1]/count_data[0])
                else:
                    assert nstep == round(count_data[1]/count_data[0]), "Different number of steps for same timer in different files"
            for file_path in pm_gpu_files:
                count_data = extract_data(file_path, timer, 8, "count")
                count_data[0] *= 8 # extract_data return number of nodes, but we need processes
                if (nstep==0):
                    nstep = round(count_data[1]/count_data[0])
                else:
                    assert nstep == round(count_data[1]/count_data[0]), "Different number of steps for same timer in different files"
            for file_path in pm_cpu_files:
                count_data = extract_data(file_path, timer, 8, "count")
                count_data[0] *= 8 # extract_data return number of nodes, but we need processes
                if (nstep==0):
                    nstep = round(count_data[1]/count_data[0])
                else:
                    assert nstep == round(count_data[1]/count_data[0]), "Different number of steps for same timer in different files"

            assert nstep != 0, "Must have num steps>0"
            nsteps[timer] = nstep
            #nsteps[timer] = 1
        print(nsteps)

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
    elif plot_type == "eff":
        aurora_dat = convert_to_efficiency(aurora_timer_data, nsteps, 12)
        aurora_dat2 = convert_to_efficiency(aurora_timer_data2, nsteps, 12)
        frontier_dat = convert_to_efficiency(frontier_timer_data, nsteps, 8)
        pm_gpu_dat = convert_to_efficiency(pm_gpu_timer_data, nsteps, 4)
        pm_cpu_dat = convert_to_efficiency(pm_cpu_timer_data, nsteps, 128)

    if plot_type == "sypd" or plot_type == "eff":
        if plot_type == "sypd": print("AURORA (SYPD):")
        elif plot_type == "eff": print("AURORA (EFFICIENCY):")
        print(aurora_dat)
    print("AURORA (TIME):")
    print(aurora_timer_data)
    if plot_type == "sypd" or plot_type == "eff":
        if plot_type == "sypd": print("AURORA2 (SYPD):")
        elif plot_type == "eff": print("AURORA2 (EFFICIENCY):")
        print(aurora_dat2)
    print("AURORA2 (TIME):")
    print(aurora_timer_data2)
    if plot_type == "sypd" or plot_type == "eff":
        if plot_type == "sypd": print("FRONTIER (SYPD):")
        elif plot_type == "eff": print("FRONTIER (EFFICIENCY):")
        print(frontier_dat)
    print("FRONTIER (TIME):")
    print(frontier_timer_data)
    if plot_type == "sypd" or plot_type == "eff":
        if plot_type == "sypd": print("PM-GPU (SYPD):")
        elif plot_type == "eff": print("PM-GPU (EFFICIENCY):")
        print(pm_gpu_dat)
    print("PM-GPU (TIME):")
    print(pm_gpu_timer_data)
    if plot_type == "sypd" or plot_type == "eff":
        if plot_type == "sypd": print("PM-CPU (SYPD):")
        elif plot_type == "eff": print("PM-CPU (EFFICIENCY):")
        print(pm_cpu_dat)
    print("PM-CPU (TIME):")
    print(pm_cpu_timer_data)

    # Plot the combined data
    plot_data(aurora_dat, aurora_dat2, frontier_dat, pm_gpu_dat, pm_cpu_dat, plot_type, timing_col, no_title)

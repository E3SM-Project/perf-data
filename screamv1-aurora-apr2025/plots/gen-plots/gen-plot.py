import argparse
import sys
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import re
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

                    return number_of_nodes, float(timing_col_cleaned)

            # If the name is not found, return None
            print(f"Error: Target name '{target_name}' not found in file '{file_path}'.")
            return None

    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        return None
    except Exception as e:
        print(f"Error: An unexpected error occurred - {e}")
        return None

def convert_to_sdpd(timer_data, simulation_length_in_days):
    # Convert runtime to simulated days per day
    sdpd_data = {}
    for timer, data in timer_data.items():
        sdpd_data[timer] = {
            "nodes": data["nodes"],
            "values": [(simulation_length_in_days/value)*60*60*24 for value in data["values"]]
        }
    return sdpd_data

def plot_data(aurora_timer_data, frontier_timer_data, plot_type, timing_col):
    fig, ax = plt.subplots(figsize=(8, 6))

    markers = ['o', 'v', 's', 'd', 'x', '*', 'p', 'h', '^']
    colors = ['b', 'g', 'r', 'm', 'y', 'c']
    idx=0
    for timer, data in aurora_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        ax.plot(sorted_nodes, sorted_values, linestyle='-',marker=markers[idx], markerfacecolor='none', color=colors[idx], label=timer)
        idx+=1
    idx=0
    for timer, data in frontier_timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        ax.plot(sorted_nodes, sorted_values, linestyle='-.',marker=markers[idx], markerfacecolor='none', color=colors[idx])
        idx+=1

    # Dummy lines for machine
    aurora_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in aurora_timer_data.values())
    frontier_is_empty = all(len(timer_data["nodes"]) == 0 for timer_data in frontier_timer_data.values())
    if not aurora_is_empty and not frontier_is_empty:
        ax.plot([],[],linestyle='-',color='k',label='Aurora')
        ax.plot([],[],linestyle='-.',color='k',label='Frontier')

    # Calculate "optimal scaling" line
    unique_nodes = sorted(set([int(node) for timer_data in [aurora_timer_data, frontier_timer_data] for timer in timer_data.values() for node in timer["nodes"]]))
    if not aurora_is_empty:
        first_values = [data["values"][0] for data in aurora_timer_data.values()]  # First data point for each timer
    else:
        first_values = [data["values"][0] for data in frontier_timer_data.values()]  # First data point for each timer
    optimal_start = statistics.median(first_values)  # Median of first data points
    if plot_type=="sdpd":
        optimal_values = [optimal_start * (2 ** i) for i in range(len(unique_nodes))]  # Double for each subsequent node

    else:
        optimal_values = [optimal_start / (2 ** i) for i in range(len(unique_nodes))]  # Halve for each subsequent node

    # Plot "optimal scaling" line
    ax.plot(unique_nodes, optimal_values, linestyle='--', color='black')

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("# of Nodes")
    y_label = "Elapsed time (s)" if plot_type=="time" else "Simulated Days per Wallclock Day (SDPD)"
    ax.set_ylabel(y_label)
    #ax.set_ylim(2e2, 1e3)
    ax.legend()
    ax.grid(True, which="both", linestyle="--", linewidth=0.5)

    if not aurora_is_empty and not frontier_is_empty:
        ax.set_title("Aurora and Frontier Scalaing ("+timing_col+")")
    elif not aurora_is_empty:
        ax.set_title("Aurora Scalaing ("+timing_col+")")
    else:
        ax.set_title("Frontier Scalaing ("+timing_col+")")

    unique_labels = [str(node) for node in unique_nodes]
    ax.set_xticks(unique_nodes)
    ax.set_xticklabels(unique_labels)
    ax.xaxis.minorticks_off()

    plt.show()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot Simulated Days per Wallclock Day (SDPD) for timing data.")
    parser.add_argument("--aurora_files", required=False, help="Comma-separated list of input files containing Aurora timing data.")
    parser.add_argument("--frontier_files", required=False, help="Comma-separated list of input files containing Frontier timing data.")
    parser.add_argument("--timers", required=True, help="Comma-separated list of timer names to plot.")
    parser.add_argument("--timing_column", type=str, default="wallmax", help="Name of column to select timing data from.")
    parser.add_argument("--plot_type", type=str, choices=["sdpd", "time"], default="sdpd", help="Y-axis on plot. Default is \"sdpd\".")
    parser.add_argument("--simulation_length_in_days", type=float, default=0.5, help="Length of the simulation in days. Default is 0.5.")
    args = parser.parse_args()

    if not args.aurora_files and not args.frontier_files:
        print(f"No data files passed.")
        sys.exit(1)

    aurora_files = args.aurora_files.split(",") if args.aurora_files else []
    frontier_files = args.frontier_files.split(",") if args.frontier_files else []
    timers = args.timers.split(",")
    timing_col = args.timing_column
    plot_type = args.plot_type
    simulation_length_in_days = args.simulation_length_in_days

    # Initialize timer data structure
    aurora_timer_data = {timer: {"nodes": [], "values": []} for timer in timers}
    frontier_timer_data = {timer: {"nodes": [], "values": []} for timer in timers}

    # Process Aurora files
    for file_path in aurora_files:
        for timer in timers:
            data = extract_data(file_path, timer, 12, timing_col)
            if data is None:
                sys.exit(1)
            aurora_timer_data[timer]["nodes"].append(data[0])
            aurora_timer_data[timer]["values"].append(data[1])

    # Process Frontier files
    for file_path in frontier_files:
        for timer in timers:
            data = extract_data(file_path, timer, 8, timing_col)
            if data is None:
                sys.exit(1)
            frontier_timer_data[timer]["nodes"].append(data[0])
            frontier_timer_data[timer]["values"].append(data[1])

    # Convert data to SDPD if needed
    aurora_dat = aurora_timer_data if plot_type == "time" else convert_to_sdpd(aurora_timer_data, simulation_length_in_days)
    frontier_dat = frontier_timer_data if plot_type == "time" else convert_to_sdpd(frontier_timer_data, simulation_length_in_days)

    print("AURORA:")
    print(aurora_dat)
    print("\nFrontier:")
    print(frontier_dat)

    # Plot the combined data
    plot_data(aurora_dat, frontier_dat, plot_type, timing_col)

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

def extract_data(file_path, target_name):
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

            # Find the 'wallmax' column and 'processes' column
            wallmax_index = next((i for i, col in enumerate(columns) if col == "wallmax"), None)
            processes_index = next((i for i, col in enumerate(columns) if col == "processes"), None)

            # Ensure both columns exist
            if wallmax_index is None or processes_index is None:
                print(f"Error: Required columns ('wallmax' or 'processes') not found in file '{file_path}'.")
                return None

            # Add double quotes around the target name
            quoted_target_name = f'"{target_name}"'

            # Iterate through the remaining lines to find the target name
            for line in file:
                # Preprocess the data row to remove parentheses
                parts = preprocess_line(line.strip())

                # Check if the line contains the quoted target name
                if parts[0] == quoted_target_name:
                    # Extract the 'wallmax' value and 'processes' value
                    wallmax_value = parts[wallmax_index]
                    processes_value = parts[processes_index]

                    # Clean up the 'wallmax' value to remove any extra parentheses or numbers
                    wallmax_cleaned = wallmax_value.strip()  # No need to split further since parentheses are removed
                    processes_cleaned = int(processes_value.strip())  # Convert processes to integer

                    # Calculate the number of nodes
                    number_of_nodes = processes_cleaned / 12

                    return number_of_nodes, float(wallmax_cleaned)

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
    print(sdpd_data)
    return sdpd_data

def plot_data(timer_data, plot_type):
    fig, ax = plt.subplots(figsize=(8, 6))

    markers = ['o', 'v', 's', 'd', 'x', '*', 'p', 'h', '^']
    idx=0
    for timer, data in timer_data.items():
        # Sort data based on nodes
        sorted_indices = sorted(range(len(data["nodes"])), key=lambda i: data["nodes"][i])
        sorted_nodes = [data["nodes"][i] for i in sorted_indices]
        sorted_values = [data["values"][i] for i in sorted_indices]
        ax.plot(sorted_nodes, sorted_values, linestyle='-.',marker=markers[idx%len(markers)], markerfacecolor='none', label=timer)
        idx += 1

    # Calculate "optimal scaling" line
    unique_nodes = sorted(set([int(node) for timer in timer_data.values() for node in timer["nodes"]]))
    first_values = [data["values"][0] for data in timer_data.values()]  # First data point for each timer
    optimal_start = statistics.median(first_values)  # Median of first data points
    if plot_type=="sdpd":
        optimal_values = [optimal_start * (2 ** i) for i in range(len(unique_nodes))]  # Double for each subsequent node

    else:
        optimal_values = [optimal_start / (2 ** i) for i in range(len(unique_nodes))]  # Halve for each subsequent node

    # Plot "optimal scaling" line
    ax.plot(unique_nodes, optimal_values, linestyle='--', color='black', label="Optimal Scaling")

    ax.set_xscale("log")
    ax.set_yscale("log")
    ax.set_xlabel("# of Nodes")
    y_label = "Elapsed time (s)" if plot_type=="time" else "Simulated Days per Wallclock Day (SDPD)"
    ax.set_ylabel(y_label)
    ax.legend()
    ax.grid(True, which="both", linestyle="--", linewidth=0.5)

    unique_nodes = sorted(set([int(node) for timer in timer_data.values() for node in timer["nodes"]]))
    unique_labels = [str(node) for node in unique_nodes]
    ax.set_xticks(unique_nodes)
    ax.set_xticklabels(unique_labels)
    ax.xaxis.minorticks_off()

    plt.show()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Plot Simulated Days per Wallclock Day (SDPD) for timing data.")
    parser.add_argument("--filenames", required=True, help="Comma-separated list of input files containing timing data.")
    parser.add_argument("--timers", required=True, help="Comma-separated list of timer names to plot.")
    parser.add_argument("--plot_type", type=str, choices=["sdpd", "time"], default="sdpd", help="Y-axis on plot. Default is \"sdpd\".")
    parser.add_argument("--simulation_length_in_days", type=float, default=0.5, help="Length of the simulation in days. Default is 0.5.")
    args = parser.parse_args()

    filenames = args.filenames.split(",")
    timers = args.timers.split(",")
    plot_type = args.plot_type
    simulation_length_in_days = args.simulation_length_in_days

    timer_data = {timer: {"nodes": [], "values": []} for timer in timers}

    for file_path in filenames:
        for timer in timers:
            data = extract_data(file_path, timer)
            if data is None:
                sys.exit(1)
            timer_data[timer]["nodes"].append(data[0])
            timer_data[timer]["values"].append(data[1])

    dat = timer_data if plot_type=="time" else convert_to_sdpd(timer_data, simulation_length_in_days)
    plot_data(dat, plot_type)

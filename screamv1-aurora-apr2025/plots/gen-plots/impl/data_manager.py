import re

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

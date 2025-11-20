import re

def preprocess_line(line):
    # Remove text within parentheses using regex
    cleaned_line = re.sub(r'\s*\(.*?\)', '', line)
    # Split the line by spaces, preserving quoted names
    return re.findall(r'"[^"]*"|\S+', cleaned_line.strip())

def extract_data(file_path, target_name, procs_per_node, timing_col, simulation_length_in_days, plot_type, machine_name):
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

        return_nodes = -1
        return_data = -1

        total_time = 0
        timer_names = [f'"{name.strip()}"' for name in target_name.split("+")]
        found_timers = 0
        for line in file:
            # Preprocess the data row to remove parentheses
            parts = preprocess_line(line.strip())
            if len(parts)==0:
                break

            if parts[0] in timer_names:
                found_timers+=1

                # Extract the timing_col value and 'processes' value
                timing_col_value = parts[timing_col_index]
                processes_value = parts[processes_index]

                # Clean up the timing_col value to remove any extra parentheses or numbers
                timing_col_cleaned = float(timing_col_value.strip())  # No need to split further since parentheses are removed
                processes_cleaned = int(processes_value.strip())  # Convert processes to integer

                # Calculate the number of nodes
                number_of_nodes = processes_cleaned / procs_per_node
                if return_nodes == -1:
                    return_nodes = number_of_nodes
                elif return_nodes != number_of_nodes:
                    print(f"Error: Node calculation did not match!")
                    return None

                #HACK: PM-GPU has 2x longer sim length for following runs
                if machine_name == "Permutter [NVIDIA GPU]":
                    if number_of_nodes==1024 or number_of_nodes==1536:
                        timing_col_cleaned/=2

                # Accumulate the time for each timer
                total_time += timing_col_cleaned

        if found_timers != len(timer_names):
            print(f"Error: Did not find the correct number of timers. {timer_names} needed, only found {found_timers} timers.")
            return None

        # Convert data if necessary
        if plot_type == "time":
            return_data = total_time
        elif plot_type == "sypd":
            return_data = 60*60*24*(simulation_length_in_days/365.25)/total_time
        elif plot_type == "sdpd":
            return_data = 60*60*24*simulation_length_in_days/total_time
        else:
            print(f"Error: Unrecognized plot type '{plot_type}'. Must use 'time', 'sypd', or 'sdpd'.")
            return None

    return [return_nodes, return_data]


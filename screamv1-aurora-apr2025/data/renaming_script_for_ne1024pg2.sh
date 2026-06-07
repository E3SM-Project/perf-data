#!/bin/bash

# Check if the prefix, nnodes number, and directory are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <prefix> <nnodes> <directory>"
    exit 1
fi

# Get the prefix, nnodes number, and directory from the command-line arguments
prefix=$1
nnodes=$2
directory=$3

# Check if the specified directory exists
if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist."
    exit 1
fi

# Loop through all files matching the pattern in the specified directory
for file in "$directory"/e3sm_timing_stats.*-*; do
    # Check if the file exists (to avoid errors if no files match the pattern)
    if [ ! -f "$file" ]; then
        echo "No files matching the pattern found in '$directory'."
        exit 1
    fi

    # Extract the {some_numbers}-{some_other_numbers} part of the filename
    suffix=$(basename "$file" | sed -E 's/e3sm_timing_stats\.([0-9]+-[0-9]+)/\1/')
    
    # Construct the new filename
    new_filename="${prefix}.ne1024pg2_ne1024pg2.F2010-SCREAMv1.nnodes${nnodes}.${suffix}"
    
    # Rename the file
    mv "$file" "$directory/$new_filename"
    
    echo "Renamed $file to $directory/$new_filename"
done


#!/bin/bash

# Activate conda enviornment taxconverter

# Input directory containing Kraken2 output files
input_dir="/workdir/kraken2_output"

# File pattern to process
file_pattern="seqid_*_kraken2_output.tsv"

# Debugging: Print the directory and pattern being used
echo "Looking for files in: ${input_dir}/${file_pattern}"

# Loop through each matching file in the input directory
for input_file in ${input_dir}/${file_pattern}; do
    # Check if file exists
    if [[ ! -f "$input_file" ]]; then
        echo "File not found: $input_file"
        continue
    fi
    
    # Extract the base file name without the directory
    base_name=$(basename "$input_file" _kraken2_output.tsv)
    
    # Define the output file name
    output_file="${input_dir}/${base_name}_kraken2_taxconverter.tsv"
    
    # Run taxconverter
    taxconverter kraken2 -i "$input_file" -o "$output_file"
    
    # Log the conversion status
    echo "Converted $input_file -> $output_file"
done

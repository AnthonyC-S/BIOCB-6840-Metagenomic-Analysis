#!/bin/bash

# Directory containing the raw TSV files
raw_tsv_dir="." # Change to the directory where your raw TSV files are located

# Loop through all raw TSV files
for raw_file in "${raw_tsv_dir}"/*_abundances_raw.tsv; do
    # Extract the sample name from the file name
    sample_name=$(basename "$raw_file" | sed -E 's/_abundances_raw\.tsv$//')

    # Generate the output file name
    filtered_file="${raw_file/_abundances_raw.tsv/_abundances.tsv}"

    # Filter the raw file to keep only nodes with length >= 250 and add the header
    awk -v sample_name="$sample_name" -v OFS='\t' '
    BEGIN { print "contigname", sample_name }
    $1 ~ /NODE/ {
        split($1, parts, "_")
        for (i in parts) {
            if (parts[i] ~ /^length$/ && parts[i+1] >= 250) {
                print $1, $2
                break
            }
        }
    }' "$raw_file" > "$filtered_file"

    # Log the filtering status
    echo "Filtered $raw_file -> $filtered_file"
done

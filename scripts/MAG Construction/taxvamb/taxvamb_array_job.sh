#!/bin/bash
#SBATCH --job-name=taxvamb_array    # Job name
#SBATCH --ntasks=1                  # Run a single task per array element
#SBATCH --cpus-per-task=4           # Number of CPU cores per task
#SBATCH --mem=8gb                   # Job memory
#SBATCH --array=0-39%20             # Array index range (adjust as needed)
#SBATCH --output=%j_array_%A-%a.log # Log file name

# Activate conda environment vamb before running

# Update the workdir, etc. and set desired directory locations.

# Define paths
ABUNDANCE_DIR="/workdir/strobealign_output/abundances_filtered_250bp"
TAXONOMY_DIR="/workdir/kraken2_output/taxvector_250bp_filtered_output"
CONTIG_LIST="/workdir/taxvamb_input/contig_files.txt" # File listing contig paths
OUTPUT_DIR="/workdir/taxvamb_output/full_run"

# Get the line corresponding to the current array index
contig_path=$(sed -n "$((SLURM_ARRAY_TASK_ID + 1))p" "$CONTIG_LIST")
echo "contig_path: $contig_path"

# Extract `seqid` from the contig path
seqid=$(basename "$(dirname "$contig_path")")
echo "seqid: $seqid"

# Generate paths for abundance and taxonomy files
abundance_file="${ABUNDANCE_DIR}/${seqid}_abundances.tsv"
echo "abundance_file: $abundance_file"

taxonomy_file="${TAXONOMY_DIR}/${seqid}_kraken2_taxconverter.tsv"
echo "taxonomy_file: $taxonomy_file"

# Create output directory for the current seqid
seqid_output_dir="${OUTPUT_DIR}/${seqid}"
echo "seqid_output_dir: $seqid_output_dir"

# Run the taxvamb command
vamb bin taxvamb \
    --outdir "$seqid_output_dir" \
    --fasta "$contig_path" \
    -m 250 \
    -o "" \
    --abundance_tsv "$abundance_file" \
    --taxonomy "$taxonomy_file"

# Log completion
echo "Completed taxvamb for $seqid (contig: $contig_path)"
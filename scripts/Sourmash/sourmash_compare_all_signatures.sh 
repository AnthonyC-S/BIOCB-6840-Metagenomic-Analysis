#!/bin/bash
#SBATCH --job-name=sourmash_compare
#SBATCH --mail-type=ALL
#SBATCH --mail-user=awc93@cornell.edu
#SBATCH --output=logs/sourmash_compare_%j.out
#SBATCH --error=logs/sourmash_compare_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64gb

# Remember to activate conda sourmash env

# Define directories
SIG_DIR="/workdir/awc93/abx-meta/sourmash_signatures/all_sigs_scaled-1000_k-31"
OUTPUT_DIR="$SIG_DIR/comparison_results"

# Run sourmash compare
sourmash compare *.sig --ani -o "$OUTPUT_DIR/compare_all_matrix_ani.npy" --csv "$OUTPUT_DIR/compare_all_matrix_ani.csv"

# Log completion
echo "Sourmash comparison complete."
echo "Results stored in $OUTPUT_DIR."

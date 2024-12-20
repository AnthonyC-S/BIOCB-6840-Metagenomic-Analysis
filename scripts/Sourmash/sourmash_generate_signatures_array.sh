#!/bin/bash
#SBATCH --job-name=sourmash_compute
#SBATCH --output=logs/%j_array_%A-%a.log
#SBATCH --error=logs/%j_array_%A-%a.err
#SBATCH --array=0-39
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5gb

# Make sure to activate sourmash conda enviornment before running script

# Note, reads_postqc are all trimmed paired end reads post quality control.

# Define variables
INPUT_DIR="/path/to/dir/reads_postqc"
OUTPUT_DIR="/path/to/dir/all_sigs_scaled-1000_k-31"

# Populate SEQID_LIST with an array of seqid folder paths
SEQID_LIST=($(find "$INPUT_DIR" -mindepth 3 -maxdepth 3 -type d -name "seqid_*" | uniq))

# Get the folder for this array task. Currently fastq file are stored in this directory structure:
# reads_postqc/
# ├── before_treatment/
# │   ├── JAX/
# │   │   ├── seqid_1/
# │   │   │   ├── seqid_1.trim_1.fastq
# │   │   │   └── seqid_1.trim_2.fastq
# │   │   ├── seqid_2/
# │   │   │   ├── seqid_2.trim_1.fastq
# │   │   │   └── seqid_2.trim_2.fastq
# │   ├── TAC/
# │   │   ├── seqid_11/
# │   │   │   ├── seqid_11.trim_1.fastq
# │   │   │   └── seqid_11.trim_2.fastq
# │   │   ├── seqid_12/
# │   │   │   ├── seqid_12.trim_1.fastq
# │   │   │   └── seqid_12.trim_2.fastq
# ├── after_treatment/
# │   ├── TAC/
# │   │   ├── seqid_21/
# │   │   │   ├── seqid_21.trim_1.fastq
# │   │   │   └── seqid_21.trim_2.fastq
# │   │   ├── seqid_22/
# │   │   │   ├── seqid_22.trim_1.fastq
# │   │   │   └── seqid_22.trim_2.fastq

SEQID_FOLDER=${SEQID_LIST[$SLURM_ARRAY_TASK_ID]}
SEQID=$(basename "$SEQID_FOLDER")
OUTPUT_PATH="$OUTPUT_DIR/${SEQID_FOLDER#$INPUT_DIR/}"

# Locate fastq files
TRIM1="$SEQID_FOLDER/${SEQID}.trim_1.fastq"
TRIM2="$SEQID_FOLDER/${SEQID}.trim_2.fastq"

# Debug: Log information
echo "Processing SEQID_FOLDER: $SEQID_FOLDER"
echo "SEQID: $SEQID"
echo "OUTPUT_PATH: $OUTPUT_PATH"
echo "TRIM1: $TRIM1"
echo "TRIM2: $TRIM2"

# Run sourmash
sourmash sketch dna -p k=31,scaled=1000,abund --merge "$SEQID" -o "$OUTPUT_DIR/${SEQID}.sig" "$TRIM1" "$TRIM2"

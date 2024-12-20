#!/bin/bash
#SBATCH --job-name=kraken2_array    # Job name
#SBATCH --ntasks=1                  # Run a single task
#SBATCH --mem=240gb                 # Job Memory
#SBATCH --cpus-per-task=80          # Number of CPU cores per task
#SBATCH --array=0-39                # Array range for 40 tasks

# Need to download the custom database, MRGM (Mouse Reference Gut Microbiome) https://www.decodebiome.org/MRGM/

# Download Kraken2 custom database link
# https://www.decodebiome.org/MRGM/listdir.php?directory=data/genome_catalog/MRGM_custom_db/MRGM_kraken2_customdb/

# Download database to /workdir/databases/MRGM_kraken2/
# Size of database ~30 GB

# Load modules or activate environment if necessary
export PATH=/programs/kraken2.1.3:$PATH
export OMP_NUM_THREADS=80

# Define the file containing paths to the contigs
CONTIGS_LIST="/workdir/kraken2_output/contig_files.txt"

# Extract the path for the current task based on SLURM_ARRAY_TASK_ID
CONTIG_PATH=$(sed -n "$((SLURM_ARRAY_TASK_ID + 1))p" "$CONTIGS_LIST")

# Extract the seqid from the path for naming outputs
SEQID=$(basename "$(dirname "$CONTIG_PATH")")

# Define output directory
OUTPUT_DIR="/workdir/kraken2_output"
mkdir -p "$OUTPUT_DIR"

# Run Kraken2
kraken2 --db /workdir/databases/MRGM_kraken2/ \
        --threads 80  \
        --report "$OUTPUT_DIR/${SEQID}_kraken2_report.tsv" \
        --output "$OUTPUT_DIR/${SEQID}_kraken2_output.tsv" \
        --classified-out "$OUTPUT_DIR/${SEQID}_classified.fq" \
        --unclassified-out "$OUTPUT_DIR/${SEQID}_unclassified.fq" \
        "$CONTIG_PATH"

# Log completion
echo "Finished processing $SEQID."


#!/bin/bash
#SBATCH --job-name=strobealign_array # Job name
#SBATCH --ntasks=1                   # Run a single task
#SBATCH --mem=100gb                  # Job memory
#SBATCH --cpus-per-task=80           # Number of CPUs per task
#SBATCH --output=%A_%a.log           # File name of the log file
#SBATCH --array=0-39                 # Job array index (adjust this range as needed)

# Activate conda env strobealign

# Path to the file listing contig directory locations
contig_list="contig_files.txt"

# Get the total number of lines in the contig list
total_lines=$(wc -l < "$contig_list")

# Calculate the total number of jobs in the array
num_jobs=40

# Calculate lines per job (adjust if needed)
lines_per_job=$(( (total_lines + num_jobs - 1) / num_jobs ))

# Get the range of lines for this job
start_line=$(( SLURM_ARRAY_TASK_ID * lines_per_job + 1 ))
end_line=$(( (SLURM_ARRAY_TASK_ID + 1) * lines_per_job ))

# Limit the end line to the actual number of lines in the file
if [ "$end_line" -gt "$total_lines" ]; then
    end_line=$total_lines
fi

# Process the contig files for this job's line range
sed -n "${start_line},${end_line}p" "$contig_list" | while IFS= read -r contig_path; do
    # Extract the seqid from the contig path
    seqid=$(basename "$(dirname "$contig_path")")

    # Construct the folder path for paired-end reads (adjusted for correct structure)
    read_folder=$(dirname "$contig_path" | sed 's|spades_output|reads_postqc|')

    # Paths to the paired-end reads
    read1="$read_folder/${seqid}.trim_1.fastq"
    read2="$read_folder/${seqid}.trim_2.fastq"

    echo "$contig_path"
    echo "$read1"
    echo "$read2"

    # Check if the files exist
    if [[ -f "$contig_path" && -f "$read1" && -f "$read2" ]]; then
        # Run strobealign
        strobealign -t 80 --aemb "$contig_path" "$read1" "$read2" > "${seqid}_abundances_raw.tsv"

    else
        echo "Missing files for $seqid. Skipping..."
    fi
done

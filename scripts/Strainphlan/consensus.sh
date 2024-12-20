#!/bin/bash
#SBATCH --job-name=bowtie2      	     # Job name
#SBATCH --mail-type=FAIL            	 # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=yc2785@cornell.edu # Where to send mail
#SBATCH --ntasks=1                   	 # Run a single task
#SBATCH --mem=100gb                    # Job Memory
#SBATCH --time=12:00:00             	 # Time limit hrs:min:sec
#SBATCH --output=%j.log		    	       # Standard output and error log


# Step 1: Loop through all .json.bz2 files in the consensus_markers folder
for json_file in ./consensus_markers/*.json.bz2; do
    # Extract the base name (seqid number) from the json filename
    seqid=$(basename ${json_file} .json.bz2)

    # Step 2: Decompress and extract markers and sequences from the current file
    bzcat ${json_file} | jq -r '.consensus_markers[] | "\(.marker) \(.sequence)"' > ${seqid}_markers.txt

    # Step 3: Extract marker names and sort them
    cut -d' ' -f1 ${seqid}_markers.txt | sort > ${seqid}_markers_list.txt
done

# Step 4: Count markers across all files
# Initialize a file to store marker counts
> marker_counts.txt

# Loop through all markers in each file and count their occurrences
for json_file in ./consensus_markers/*.json.bz2; do
    seqid=$(basename ${json_file} .json.bz2)
    cut -d' ' -f1 ${seqid}_markers.txt >> marker_counts.txt
done

# Sort and count occurrences of each marker
sort marker_counts.txt | uniq -c | awk '$1 >= 10 {print $2}' > markers_shared_by_10_or_more.txt

# Step 5: Prepare output file
> shared_markers_output.txt  # Clear existing file or create new

# Step 6: Loop through shared markers and extract sequences for each file, output to structured format
while read -r marker; do
    echo "Marker: $marker" >> shared_markers_output.txt

    # Loop through each file and extract the sequence for the current marker
    for json_file in ./consensus_markers/*.json.bz2; do
        seqid=$(basename ${json_file} .json.bz2)
        seq=$(grep "$marker" ${seqid}_markers.txt | cut -d' ' -f2)
        if [ -n "$seq" ]; then  # Only output if the sequence exists
            echo "${seqid} Sequence: $seq" >> shared_markers_output.txt
        fi
    done

    echo "" >> shared_markers_output.txt  # Add a blank line between markers
done < markers_shared_by_10_or_more.txt

# Step 7: Verify the result
cat shared_markers_output.txt

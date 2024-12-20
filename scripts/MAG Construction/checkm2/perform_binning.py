import os
from Bio import SeqIO
from collections import defaultdict

# Activate conda env biopython

# Input: Path to the file listing contig files and base directory for TSV files. May need to modify directory path.
contig_files_list = "/workdir/taxvamb_output/full_run/contig_files.txt"
tsv_base_dir = "/workdir/taxvamb_output/full_run"
output_base_dir = "/workdir/taxvamb_output/full_run/bins"

# Function to perform binning for a given TSV and contig FASTA file
def perform_binning(tsv_file, fasta_file, output_dir):
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)

    # Parse the TSV file to map contigs to bins
    bin_map = defaultdict(list)
    with open(tsv_file, "r") as f:
        for line in f:
            bin_num, contig_name = line.strip().split("\t")
            bin_map[bin_num].append(contig_name)

    # Read the contigs FASTA file
    contigs = SeqIO.to_dict(SeqIO.parse(fasta_file, "fasta"))

    # Write contigs into bin-specific FASTA files
    for bin_num, contig_names in bin_map.items():
        bin_fasta_file = os.path.join(output_dir, f"bin_{bin_num}.fasta")
        with open(bin_fasta_file, "w") as out_f:
            for contig_name in contig_names:
                if contig_name in contigs:
                    SeqIO.write(contigs[contig_name], out_f, "fasta")

# Process each line in the contig_files.txt
with open(contig_files_list, "r") as f:
    for line in f:
        fasta_path = line.strip()
        
        # Extract seqid_# from the path
        seqid_folder = os.path.basename(os.path.dirname(fasta_path))  # Extract seqid_#
        tsv_file = os.path.join(tsv_base_dir, seqid_folder, "vaevae_clusters_unsplit.tsv")
        
        # Define output directory for the bins
        output_dir = os.path.join(output_base_dir, seqid_folder)
        
        # Check if both FASTA and TSV files exist
        if os.path.exists(fasta_path) and os.path.exists(tsv_file):
            print(f"Processing {seqid_folder}...")
            perform_binning(tsv_file, fasta_path, output_dir)
        else:
            print(f"Skipping {seqid_folder}: Missing input files (FASTA or TSV)")
from Bio import SeqIO
from collections import defaultdict
import os

# Input files
tsv_file = "vaevae_clusters_unsplit.tsv"
fasta_file = "contigs.fasta"
output_dir = "filtered_bins"
length_threshold = 750000  # Minimum total length (bp) per bin

# Create output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)

# Parse the TSV file to map contigs to bins
bin_map = defaultdict(list)
with open(tsv_file, "r") as f:
    for line in f:
        bin_num, contig_name = line.strip().split("\t")
        bin_map[bin_num].append(contig_name)

# Calculate total sequence length per bin
bin_lengths = defaultdict(int)
contig_sequences = SeqIO.to_dict(SeqIO.parse(fasta_file, "fasta"))

for bin_num, contig_names in bin_map.items():
    for contig_name in contig_names:
        if contig_name in contig_sequences:
            bin_lengths[bin_num] += len(contig_sequences[contig_name].seq)

# Filter bins and write FASTA files for bins above the threshold
for bin_num, total_length in bin_lengths.items():
    if total_length >= length_threshold:
        bin_fasta_file = os.path.join(output_dir, f"bin_{bin_num}.fasta")
        with open(bin_fasta_file, "w") as out_f:
            for contig_name in bin_map[bin_num]:
                if contig_name in contig_sequences:
                    SeqIO.write(contig_sequences[contig_name], out_f, "fasta")

# Summary of filtered bins
print(f"Bins above {length_threshold} bp: {len([b for b in bin_lengths if bin_lengths[b] >= length_threshold])}")
print(f"Filtered bins are saved in: {output_dir}")

#!/usr/bin/env python3

# Activate conda env biopython

from Bio import SeqIO
import argparse
import os

def n50_calculation(contigs_file):
    # calculate contig length from parsed fasta file
    contig_lengths = [len(contig.seq) for contig in SeqIO.parse(contigs_file, "fasta")]
    
    # sort lengths of the different contigs(descending order)
    contig_lengths.sort(reverse=True)
    
    # total assembly size
    total_length = sum(contig_lengths)
    
    # calculation of N50 value
    # initialize cumulative length
    cumulative_length = 0
    for length in contig_lengths:
        cumulative_length += length
        if cumulative_length >= total_length / 2:
            return length

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="calculate N50 values from child directories named seqid that contains a spades_output folder.")
    parser.add_argument(
        "base_directory", 
        help="base directory to search for 'seqid' folders containing spades_output/contigs.fasta."
    )
    parser.add_argument(
        "-o", "--output_file", default="n50_results.txt", help="path to save compiled N50 results (n50_results.txt)"
    )
    args = parser.parse_args()

    # open output file, to write n50 calculation outputs
    with open(args.output_file, "w") as out_file:
        out_file.write("File\tN50\n") # column titles

        # loop for all directors with seqid in their name
        for folder in os.listdir(args.base_directory):
            if "seqid" in folder: 
                # check if folder name contains seqid
                input_dir = os.path.join(args.base_directory, folder)
                
                # specify path to the contigs.fasta file in the seqid folder
                contigs_file = os.path.join(input_dir, "contigs.fasta")
                
                if os.path.exists(contigs_file):
                    # calculate N50 value
                    n50 = n50_calculation(contigs_file)
                    # write 
                    out_file.write(f"{contigs_file}\t{n50}\n")
                else:
                    # If contigs.fasta doesn't exist, log a warning
                    out_file.write(f"{contigs_file}\tFile not found\n")

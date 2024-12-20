#!/usr/bin/env python3

from Bio import SeqIO
import argparse
import os

def contig_length_calculation(contigs_file):
    # initialize an empty contig length list
    contig_lengths = []
    # list out each contig ID and each contig length
    for contig in SeqIO.parse(contigs_file, "fasta"):
        contig_lengths.append((contig.id, len(contig.seq)))
    return contig_lengths

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="extract contig lengths from a list of samples in folders named seqid")
    parser.add_argument(
        "base_directory", 
        help="base directory to search for 'seqid' folders containing contigs.fasta."
    )
    parser.add_argument(
        "-o", "--output_file", default="contig_lengths.txt", help="path to save compiled contig lengths"
    )
    args = parser.parse_args()

    # open output file, to write n50 calculation outputs
    with open(args.output_file, "w") as out_file:
        out_file.write("Sample\tContig\tLength\n") # column titles

        # loop for all directors with seqid in their name
        for folder in os.listdir(args.base_directory):
            if "seqid" in folder: 
                # check if folder name contains seqid
                input_dir = os.path.join(args.base_directory, folder)
                
                # specify path to the contigs.fasta file in the seqid folder
                contigs_file = os.path.join(input_dir, "contigs.fasta")
                
                if os.path.exists(contigs_file):
                    # calculate contig lengths for each sample
                    contig_lengths = contig_length_calculation(contigs_file)
                    # write the lengths in the txt file, specifying the folder, contig id, and length
                    for contig_id, length in contig_lengths:
                        out_file.write(f"{folder}\t{contig_id}\t{length}\n")
                else:
                    # If contigs.fasta doesn't exist, log a warning
                    out_file.write(f"{contigs_file}\tFile not found\n")

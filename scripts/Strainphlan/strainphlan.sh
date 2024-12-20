#!/bin/bash
#SBATCH --job-name=bowtie2      	     # Job name
#SBATCH --mail-type=FAIL            	 # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=yc2785@cornell.edu # Where to send mail
#SBATCH --ntasks=1                   	 # Run a single task
#SBATCH --mem=50gb                    # Job Memory
#SBATCH --time=12:00:00             	 # Time limit hrs:min:sec
#SBATCH --output=%j.log		    	       # Standard output and error log

mkdir -p output
strainphlan -s consensus_markers/*.json.bz2 -m db_markers/t__SGB7041.fna -r <reference genome> -o output -n 8 -c t__SGB7041 --mutation_rates 

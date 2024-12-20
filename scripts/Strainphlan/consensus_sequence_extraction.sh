#!/bin/bash
#SBATCH --job-name=consensus_markers      	     # Job name
#SBATCH --mail-type=FAIL            	 # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=yc2785@cornell.edu # Where to send mail
#SBATCH --ntasks=16                   	 # Run a single task
#SBATCH --mem=20gb                    # Job Memory
#SBATCH --time=24:00:00             	 # Time limit hrs:min:sec
#SBATCH --output=%j.log		    	       # Standard output and error log

mkdir -p consensus_markers
sample2markers.py -i sams/*.sam.bz2 -o consensus_markers -n 16


#!/bin/bash
#SBATCH --job-name=bowtie2      	     # Job name
#SBATCH --mail-type=FAIL            	 # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=yc2785@cornell.edu # Where to send mail
#SBATCH --ntasks=1                   	 # Run a single task
#SBATCH --mem=8gb                    # Job Memory
#SBATCH --time=12:00:00             	 # Time limit hrs:min:sec
#SBATCH --output=%j.log		    	       # Standard output and error log


# List of species to process
species_list=(
  "SGB40362"
  "SGB27763"
  "SGB21428"
  "SGB5158"
  "SGB40338"
  "SGB40208"
  "SGB7077"
  "SGB40986"
  "SGB41677"
  "SGB35892"
  "SGB40310"
  "SGB41495"
  "SGB1810"
  "SGB7277"
)

# Create output directory
mkdir -p db_markers2

# Loop through each species and generate db_markers
for species in "${species_list[@]}"; do
  extract_markers.py -c t__${species} -o db_markers2/
done

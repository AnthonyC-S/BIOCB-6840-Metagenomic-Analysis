# NOTE: this analysis was done using the Brito Lab server

# Download reference db files. With wget command and extract.
# See instructions on https://ecogenomics.github.io/GTDBTk/installing/index.html, and 
# check the table to make sure the software and db versions match each other. 

# wget https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz
# tar xvfz gtdbtk_v2_data.tar.gz

# Set GTDBTK_DATA_PATH to new reference db directory, for example:
# export GTDBTK_DATA_PATH=/workdir/release207_v2

# activate the conda env gtdbtk

# Specify directory containing bins from all samples

binned_assemblies_dir=/workdir/taxvamb_output/full_run/filtered_bins
cd "$binned_assemblies_dir"

# loop through each sample folder containing the name "seqid" and execute gtdbtk for all the bins in that folder
for folder in "$binned_assemblies_dir"/*; do
    # only execute the for loop if the folder name contains "seqid"
    if [[ -d "$folder" && "$folder" == *seqid* ]]; then
        gtdbtk classify_wf \
            --genome_dir "$folder/" \
            --out_dir "gtdbtk_output/$(basename "$folder")" \
            # specify the location of the mash db inside of the GTDBTK database folder
            --mash_db /workdir/refdbs/GTDBTK_db/release220/mash_db.msh \
            --extension .fasta # change the extension if necessary
    fi
done
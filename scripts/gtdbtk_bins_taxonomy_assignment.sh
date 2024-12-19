# NOTE: this analysis was done using the Brito Lab server

# NOTE: the GTDB database must be downloaded beforehand. 
# NOTE: then, export the gtdbtk and its databases to path.
# specify directory containing bins from all samples
binned_assemblies_dir=/workdir1/lej52/abx_recovery_metagenomics/taxvamb_output/full_run/filtered_bins
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
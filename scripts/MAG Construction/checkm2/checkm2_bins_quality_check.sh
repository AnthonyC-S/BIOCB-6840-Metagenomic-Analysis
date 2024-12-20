# NOTE: this analysis was done using the Brito Lab server

# activate conda environment checkm2


# export the diamond database for checkm2
# NOTE: the database must be downloaded beforehand
export CHECKM2DB=/workdir/refdbs/checkm2_db/CheckM2_database/uniref100.KO.1.dmnd

# specify directory containing bins from all samples
binned_assemblies_dir=/workdir1/lej52/abx_recovery_metagenomics/taxvamb_output/full_run/filtered_bins
cd "$binned_assemblies_dir"

# loop through each sample folder and execute checkm2 for all the bins in that folder
for folder in "$binned_assemblies_dir"/*; do
    if [ -d "$folder" ]; then
        checkm2 predict \
            --threads 30 \
            --input "$folder" \
            --output-directory "checkm2_output/$(basename "$folder")" \
            -x .fasta # change the extension if necessary
    fi
done
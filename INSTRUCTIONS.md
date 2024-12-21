# Analysis Replication Instructions

Most of the scripts used conda environments, which are provided as `.yaml` files in the `envs` folder.

If you do not have conda installed, we recommend miniconda which can be downloaded [here](https://docs.anaconda.com/miniconda/install/).

To create a conda environment from a .yaml file:
`conda env create --file=filename.yaml`

## Sourmash Instructions

Note, you will need to update the base workdir to point to the genomic data.

1. Create a conda environment sourmash with [sourmash.yaml](envs/sourmash.yaml) and activate.
2. Run [sourmash_generate_signatures_array.sh](scripts/Sourmash/sourmash_generate_signatures_array.sh).
3. Run [sourmash_compare_all_signatures.sh](scripts/Sourmash/sourmash_compare_all_signatures.sh).
4. Deactivate sourmash env with `conda deactivate sourmash`.
5. Create a conda environment sourmash_plot with [sourmash_plot.yaml](envs/sourmash_plot.yaml) and activate.
6. Generate heatmap plots and scatter plots with `python sourmash_plot.py`, with file [sourmash_plot.py](scripts/Sourmash/sourmash_plot.py).

## MAG Construction

To generate final bins with TaxVAMB, there are many earlier steps in the pipeline involving other packages.

### Assemby Contigs with MetaSPAdes

The SPAdes package located on the BioHPC cluster, "programs/spades/bin/spades.py" was used. If you do not have access to BioHPC, please download 
and install version 4.0.0 from here: [https://ablab.github.io/spades/installation.html](https://ablab.github.io/spades/installation.html) and edit 
[metaspades_genome_assembly.sh](scripts/MAG%20Construction/metaspades/metaspades_genome_assembly.sh) to point to new package location.

1. Run [metaspades_genome_assembly.sh](scripts/MAG%20Construction/metaspades/metaspades_genome_assembly.sh).
2. Calculate contig lengths with `python post_metaspades_contig_length_calculation.py`, with file [post_metaspades_contig_length_calculation.py](scripts/MAG%20Construction/metaspades/post_metaspades_contig_length_calculation.py).
3. Calculate contig N50 data with `python post_metaspades_n50_calculation.py`, with file [post_metaspades_n50_calculation.py](scripts/MAG%20Construction/metaspades/post_metaspades_n50_calculation.py).
4. To generate MetaSPAdes figures, please download either [R](https://www.r-project.org/) or if you prefer, [RStudio](https://posit.co/downloads/), if not already installed.
5. Generate plots by running [metaspades_contig_length_plot.R](scripts/MAG%20Construction/metaspades/metaspades_contig_length_plot.R) and [metaspades_n50_plot.R](scripts/MAG%20Construction/metaspades/metaspades_n50_plot.R) in R.

### Generate Abundances with Strobealign

1. Create a conda environment strobealign with [strobealign.yaml](envs/strobealign.yaml) and activate.
2. Run [strobealign_array_job.sh](scripts/MAG%20Construction/strobealign/strobealign_array_job.sh)
3. Filter strobealign output to 250bp or more by running [filter_abundances.sh](scripts/MAG%20Construction/strobealign/filter_abundances.sh)

### Generate Contig Taxonomy with Kraken 2

Our study used a database genarated by [Mouse Reference Gut Microbiome (MRGM)](https://www.decodebiome.org/MRGM/)

1. The custom Kraken 2 database can be installed from [here](https://www.decodebiome.org/MRGM/listdir.php?directory=data/genome_catalog/MRGM_custom_db/MRGM_kraken2_customdb/), please download all files (~30 GB) and save to `/workdir/databases/MRGM_kraken2/`.
2. Load Kraken 2 path, with `export PATH=/programs/kraken2.1.3:$PATH` if on the BioHPC cluster. Otherwise install Kraken 2 with instructions [here](https://github.com/DerrickWood/kraken2/blob/master/docs/MANUAL.markdown#installation) and update path.
3. Run [kraken2_array.sh](scripts/MAG%20Construction/kraken2/kraken2_array.sh).
4. Create a conda environment taxconverter with [taxconverter.yaml](envs/taxconverter.yaml) and activate.
5. Convert the `kraken2_output.tsv` files to a formate suitable for TaxVAMB by running script [convert_kraken2_output.sh](scripts/MAG%20Construction/taxconverter/convert_kraken2_output.sh).
6. Manually remove contig lenghs less than 250 bp from the `kraken2_taxconverter.tsv` output files, or create script to do so.
   
### Generate Bins with TaxVAMB

All needed input files should now be created.
1. Create a conda environment vamb with [vamb.yaml](envs/vamb.yaml) and activate.
2. Modify any of the directories to the correct path.
3. Run script [taxvamb_array_job.sh](scripts/MAG%20Construction/taxvamb/taxvamb_array_job.sh).

### Group and Filter Bins to 500,000 bp or more

1. Create a conda environment biopython with [biopython.yaml](envs/biopython.yaml) and activate.
2. Group the bins with `python perform_binning.py` with file, [perform_binning.py](scripts/MAG%20Construction/checkm2/perform_binning.py).
3. Filter the bins requried lengths with `python filter_bins.py` with file [filter_bins.py](scripts/MAG%20Construction/checkm2/filter_bins.py).

### Check Quality of Bins with CheckM2

1. Create a conda environment checkm2 with [checkm2.yaml](envs/checkm2.yaml) and activate.
2. Download and unpack reference genome from here: [CM2 DIAMOND Reference Database Uniref100/KO](https://zenodo.org/records/4626519/files/uniref100.KO.v1.dmnd.gz?download=1).
3. Update path pointing to reference database in script, [checkm2_bins_quality_check.sh](scripts/MAG%20Construction/checkm2/checkm2_bins_quality_check.sh).
4. Run script [checkm2_bins_quality_check.sh](scripts/MAG%20Construction/checkm2/checkm2_bins_quality_check.sh).
5. Create a conda environment sourmash with [sourmash.yaml](envs/sourmash.yaml) and activate, note this environment has all the necessary packages to create CheckM2 plots as well.
6. Create plots with `python checkm2_plots.py` with file [checkm2_plots.py](scripts/MAG%20Construction/checkm2/checkm2_plots.py).

### Obtain Taxonomy with GTDB-Tk

1. Download GTDB-Tk database with wget and then unpack tar file. See installation instructions [here](https://ecogenomics.github.io/GTDBTk/installing/index.html) if you have any trouble.

    `wget https://data.gtdb.ecogenomic.org/releases/latest/auxillary_files/gtdbtk_package/full_package/gtdbtk_data.tar.gz`

    `tar xvfz gtdbtk_v2_data.tar.gz`
2. Create a conda environment gtdbtk with [gtdbtk.yaml](envs/gtdbtk.yaml) and activate.
3. Set the GTDBTK_DATA_PATH envrionment variable by running: `conda env config vars set GTDBTK_DATA_PATH="/path/to/target/db"`.
4. Update database path and run script [gtdbtk_bins_taxonomy_assignment.sh](scripts/MAG%20Construction/gtdbtk/gtdbtk_bins_taxonomy_assignment.sh).
5. To plot figures, use R or RStudio and open and run [gtdbtk_output_plots.R](scripts/MAG Construction/gtdbtk/gtdbtk_output_plots.R).


## StrainPhlAn and MetaPhlAn Analysis

To construct the phylogenetic tree, please follow the following instruction:

1. Create a conda environment metaphlan with [metaphlan.yaml](envs/metaphlan.yaml) and activate.
2. Run [alignment_and_taxonomy_profiling.sh](scripts/Strainphlan/alignment_and_taxonomy_profiling.sh) to align the metagenomic data of each sample to the marker gene database using metaphlan and generate the taxonomy profile.
3. Run [consensus_sequence_extraction.sh](scripts/Strainphlan/consensus_sequence_extraction.sh) to extract the consensus sequence of marker genes for each samples.
4. Run [species_marker_genes_extraction.sh](scripts/Strainphlan/species_marker_genes_extraction.sh) to extract from the MetaPhlAn database, the maker genes for each species of interest. The script extracted the marker gene for all the species that has at least 100 marker genes shared by more than 10 samples. In total 14 species were identified.
5. Run script [strainphlan.sh](scripts/Strainphlan/strainphlan.sh) to construct the phylogenetic tree for each species of interest across all the samples that pass the marker gene filter. Note, the script showed an example for species SGB7041.

To find all the markers that are shared by more than 10 sample. run the script [consensus.sh](scripts/Strainphlan/consensus.sh). With that we will be able to identify the top species that are shared by more than 10 samples and have the most marker genes. The species filtered and used in script `species_marker_genes_extraction.sh` are the top species that has at least 100 marker genes shared by more than 10 samples.

To construct the phylogenetic tree for only the TAC and JAX mice before treatment, replace the script `strainphlan.sh` to [donor_receipient_before.sh](scripts/Strainphlan/donor_receipient_before.sh) in step 5.

Run [hclust2.sh](scripts/Strainphlan/hclust2.sh) to generate the top 30 abundant taxonomy profile heatmap for samples of interests.

To generate the top 30 abundant taxonomy profile heatmap for only the TAC and JAX mice samples before treatment, run `python filter.py` with the file [filter.py](scripts/Strainphlan/filter.py) to filter for those samples and generate the `filtered_merged_abundance_table_species.txt` used in `hclust2.sh`.

To rename the `{seq_id}.json.bz2` files to `{seq_id}_{real_name}.json.bz2` for easy reading in the following phylogenetic tree, run `python rename.py` with the file [rename.py](scripts/Strainphlan/rename.py) before proceeding with step 5.

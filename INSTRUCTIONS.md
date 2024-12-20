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

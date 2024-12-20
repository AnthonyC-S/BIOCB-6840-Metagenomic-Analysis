# Analysis Replication Instructions

Most of the scripts used conda environments, which are provided as `.yaml` files in the `envs` folder.

If you do not have conda installed, we recommend miniconda which can be downloaded [here](https://docs.anaconda.com/miniconda/install/).

To create a conda environment:
`conda env create --file=filename.yaml`

## Sourmash Instructions

Note, you will need to update the base workdir to point to the genomic data.

1. Create a conda environment sourmash with [sourmash.yaml](envs/sourmash.yaml) and activate.
2. Run [sourmash_generate_signatures_array.sh](scripts/Sourmash/sourmash_generate_signatures_array.sh).
3. Run [sourmash_compoare_all_signatures_array.sh](scripts/Sourmash/sourmash_compare_all_signatures_array.sh).
4. Generate plots with `python sourmash_plot.py`, with file [sourmash_plot.py](scripts/Sourmash/sourmash_plot.py).

## MAG Construction

To generate final bins with TaxVAMB, there are many earlier steps in the pipeline.

### Assemby Contigs with MetaSPAdes

The SPAdes package located on the BioHPC cluster, "programs/spades/bin/spades.py" was used. If you do not have access to BioHPC, please download 
and install version 4.0.0 from here: [https://ablab.github.io/spades/installation.html](https://ablab.github.io/spades/installation.html) and edit 
[metaspades_genome_assembly.sh](scripts/MAG%20Construction/metaspades/metaspades_genome_assembly.sh) to point to new package location.

1. Run [metaspades_genome_assembly.sh](scripts/MAG%20Construction/metaspades/metaspades_genome_assembly.sh).
2. Calculate contig lengths with `python post_metaspades_contig_length_calculation.py`, with file [post_metaspades_contig_length_calculation.py](scripts/MAG%20Construction/metaspades/post_metaspades_contig_length_calculation.py).
3. Calculate contig N50 data with `python post_metaspades_contig_n50_calculation.py`, with file [post_metaspades_contig_n50_calculation.py](scripts/MAG%20Construction/metaspades/post_metaspades_contig_n50_calculation.py).
4. To generate MetaSPAdes figures, please download either [R](https://www.r-project.org/) or if you prefer, [RStudio](https://posit.co/downloads/), if not already installed.
5. Generate plots by running [metaspades_contig_length_plot.R](scripts/MAG%20Construction/metaspades/metaspades_contig_length_plot.R) and [metaspades_n50_plot.R](scripts/MAG%20Construction/metaspades/metaspades_n50_plot.R) in R.

### Generate Abundances with Strobealign

1. Create a conda environment strobealign with [strobealign.yaml](envs/strobealign.yaml) and activate.
2. Run [strobealign_array_job.sh](scripts/MAG%20Construction/strobealign/strobealign_array_job.sh)
3. Filter strobealign output to 250bp or more by running [filter_abundances.sh](scripts/MAG%20Construction/strobealign/filter_abundances.sh)

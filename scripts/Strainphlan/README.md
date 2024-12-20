To construct the phylogenetic tree, please follow the following instruction:
1) run the "alignment_and_taxonomy_profiling.sh" script to align the metagenomic data of each sample to the marker gene database using metaphlan and generate the taxonomy profile.
2) run the "consensus_sequence_extraction.sh" script to extract the consensus sequence of marker genes for each samples.
3) run the "species_marker_genes_extraction.sh" script to extract from the metaphlan database, the maker genes for each species of interest. (The script extracted the marker gene fro all the species that has at least 100 marker genes shared by more than 10 samples. In tota 14 species identified)
4) run the script "strainphlan.sh" to construct the phylogenetic tree for each species of interest across all the samples that pass the marker gene filter. (The script showed an example for species SGB7041).

To find all the markers that are shared by more than 10 sample. run the script "consensus.sh". With that we will be able to identify the top species that are shared by more than 10 samples and have the most marker genes. The species filtered and used in script "species_marker_genes_extraction.sh" are the top species that has at least 100 marker genes shared by more than 10 samples.

To construct the phylogenetic tree for only the TAC and JAX mice before treatment, replace the script "strainphlan.sh" to "donor_receipient_before.sh" in step 4).

Use the "hclust2.py" script to generate the top 30 abundant taxonomy profile heatmap for samples of interests.

To generate the top 30 abundant taxonomy profile heatmap for only the TAC and JAX mice samples before treatment, use the "filter.py" script the filter for those samples and generate the "filtered_merged_abundance_table_species.txt" used in hclust2.

To rename the "{seq_id}.json.bz2" files to "{seq_id}_{real_name}.json.bz2" for easy reading in the following phylogenetic tree, run the script "rename.py"before proceeding with step 4).

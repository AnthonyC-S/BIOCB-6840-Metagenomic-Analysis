# BIOCB-6840-Metagenomic-Analysis
The final project report and analysis for BIOCB 6840 - Computational Genetics and Genomics, at Cornell University in Fall 2024.

We are interested in classifying which microbial species in mice were transmitted from donor(s) to recipient, when the recipient is treated with antibiotics. Given that donor and recipient are from different facilities, the hypothesis is that minor sequence differences will distinguish bacterial strains, even within the same bacterial species.

## Title
Tracking Gut Microbial Transmission in Co-housed Mice Following Antibiotic Treatment

## Study Design
An experimental study was performed on mice to investigate the effects of co-housing (close social interactions) on gut microbiome recovery post-antibiotic perturbation. To ensure different base microbiomes, the recipient mice were acquired from Taconic Biosciences (TAC) and the donors from Jackson Laboratory (JAX). The acquired dataset consists of time-series DNA microbiome samples taken at days –7, 0, 7, 14, 21, 29, and 38 for recipients, and days –7, 0, and 7 for donors. Day 0 is the start of a seven-day broad spectrum antibiotic course and co-housing started on day 8. For each sample, Illumina short-read shotgun metagenomic sequencing (150bp, ~6m reads/sample) was done. This analysis will focus on days -7, 0, and 38.

## Replication Instructions
Please follow instructions to replicate the analysis and figures, found in [INSTRUCTIONS.md](INSTRUCTIONS.md).

## Group Members
- Yang Cheng (yc2785, BIOCB 6840)
- Anthony Coffin-Schmitt (awc93, BIOCB 6840)
- Luna Eresta Jaya (lej52, BIOCB 6840)

## Acknowledgments
Data collection and sequencing was possible through funding from the Brito Lab at Cornell University, [https://www.britolab.org](https://www.britolab.org).

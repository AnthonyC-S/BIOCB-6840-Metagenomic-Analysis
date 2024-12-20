library(ggplot2)
library(tidyverse)
library(ggsci)

# load all contig length data
jax_before <- read.table("C:/Users/lunae/Documents/Cornell/Computational Genomics and Genetics/project/data/contig_lengths/jax_before/contig_lengths.txt", header = TRUE, sep = "\t")
tac_before <- read.table("C:/Users/lunae/Documents/Cornell/Computational Genomics and Genetics/project/data/contig_lengths/tac_before/contig_lengths.txt", header = TRUE, sep = "\t")
tac_after <- read.table("C:/Users/lunae/Documents/Cornell/Computational Genomics and Genetics/project/data/contig_lengths/tac_after/contig_lengths.txt", header = TRUE, sep = "\t")

# indicate which populations the seqids belong to
jax_before$population <- "jax_before"
tac_before$population <- "tac_before"
tac_after$population <- "tac_after"

# combine all population contig length data
all_contigs <- rbind(jax_before, tac_before, tac_after)

# View(all_contigs)

# calculate bin width of histogram using Freedman-Diaconis rule
iqr_length <- IQR(all_contigs$Length)
bin_width <- 2 * iqr_length / (nrow(all_contigs)^(1/3))

### HISTOGRAM
# from 0 - 100,000bp contigs
ggplot(all_contigs, aes(x = Length, fill = population)) +
  geom_histogram(color = "black", alpha = 0.7) +
  xlab("Contig Length (bp)") +
  xlim(0, 100000) +
  ylim(0, 30000) +
  theme_classic() +
  scale_fill_manual(
    values = pal_npg("nrc")(3),
    labels = c("JAX don. (Before Cohousing)", 
               "TAC rec. (After Cohousing)", 
               "Tac rec. (Before Cohousing)")
  )

# from 100,000bp - max length contigs
ggplot(all_contigs, aes(x = Length, fill = population)) +
  geom_histogram(color = "black", alpha = 0.7) +
  xlab("Contig Length (bp)") +
  xlim(100000, 710000) +
  # ylim(0, 1000) +
  theme_classic() +
  scale_fill_manual(
    values = pal_npg("nrc")(3),
    labels = c("JAX don. (Before Cohousing)", 
               "TAC rec. (After Cohousing)", 
               "Tac rec. (Before Cohousing)")
  )

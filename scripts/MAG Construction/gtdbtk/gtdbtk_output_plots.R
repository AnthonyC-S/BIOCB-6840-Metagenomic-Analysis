library(readxl)
library(ggplot2)
library(tidyverse)
library(ggsci)
library(writexl)

### CLEAN UP DATA FOR PLOTTING


# load gtdbtk output file, will need to modify to workdir
gtdbtk_output <- read_excel("data/merged_gtdbtk_summary.xlsx")

# separate classification into Domain, Phylum, Class, ..., Species
gtdbtk_output <- separate(gtdbtk_output, classification, into = c("Domain", "Phylum", "Class", "Order", "Family", "Genus", "Species"), sep = ";")

# filter out unidentified species
gtdbtk_output <- gtdbtk_output %>% filter(!is.na(Species))
# View(gtdbtk_output)

# load n50 data file, will need to modify workdir
# n50 values aren't needed here, but this file contains population information for the different seqid, e.g. seqid_1 is TAC before cohousing
n50_data <- read_excel("data/n50_results/n50_all_metaspades_output.xlsx")

# add population information to gtdbtk_output by merging data
gtdbtk_output <- merge(gtdbtk_output, n50_data, by="seqid")

# save merged data if needed.
# write_xlsx(gtdbtk_output, "data/merged_gtdbtk_summary_cleaned.xlsx")


### PLOT 3 SAMPLES FIRST, USE A BINARY MATRIX PLOT

# filter gtdbtk_output to 3 samples for initial testing
gtdbtk_output_3samples <- gtdbtk_output %>% filter(seqid %in% c("seqid_14","seqid_78","seqid_88"))

# seqid_88 = TAC before cohousing (recipient mouse)
# seqid_78 = TAC after cohousing (same recipient mouse)
# seqid_14 = JAX before cohousing (specific donor mouse for the above recipient)
# rename seqids to sample info
gtdbtk_output_3samples <- gtdbtk_output_3samples %>%
  mutate(seqid = case_when(
    seqid == "seqid_88" ~ "TAC before",
    seqid == "seqid_78" ~ "TAC after",
    seqid == "seqid_14" ~ "JAX before",
    TRUE ~ seqid  # Keep other seqids unchanged
  ))

# binary matrix of presence/absence
presence_absence_matrix <- table(gtdbtk_output_3samples$seqid, gtdbtk_output_3samples$Species)

# convert to long format
presence_absence_long <- as.data.frame(as.table(presence_absence_matrix))
colnames(presence_absence_long) <- c("SeqID", "Species", "Presence")

# plot heatmap using ggplot2
ggplot(presence_absence_long, aes(x = Species, y = SeqID, fill = Presence)) +
  geom_tile(color = "white") +  
  scale_fill_gradient(low = "white", high = "skyblue") + 
  theme_classic() + 
  labs(x = "Species",
       y = "Sample Information",
       fill = "Presence") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 


### PLOT ALL SAMPLES USING BARPLOT

# group by population and species, and count the number of unique seqid
species_counts <- gtdbtk_output %>%
  group_by(population, Species) %>%
  summarise(Count = n_distinct(seqid), .groups = "drop") %>%
  # filter out bacterial species where the any group count is less than 3
  filter(Count > 2)

# custom facet title
custom_labeller <- as_labeller(c(
  "jax_before_cohousing" = "JAX before cohousing",
  "tac_after_cohousing" = "TAC after cohousing",
  "tac_before_cohousing" = "TAC before cohousing"
))

# create faceted barplot
ggplot(species_counts, aes(x = Species, y = Count, fill = Species)) +
  geom_bar(stat = "identity") +  # Standard bar plot
  facet_grid(population ~ ., scales = "free_y", labeller = custom_labeller) +  # Custom facet labels
  scale_fill_viridis_d() +  # Apply a discrete color palette
  theme_minimal() +
  labs(
    x = "Bacterial Species",
    y = "Sample Count"
  ) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size=8),  # Rotate x-axis labels
    plot.title = element_text(hjust = 0.5),  # Center the title
    legend.position = "none"  # Remove the legend
  )
library(readxl)
library(ggplot2)
library(tidyverse)
library(ggsci)

n50_data <- read_excel("C:/Users/lunae/Documents/Cornell/Computational Genomics and Genetics/project/data/n50_results/n50_all_metaspades_output.xlsx")
View(n50_data)

### HISTOGRAM
ggplot(n50_data, aes(x = N50, fill = population)) +
  geom_histogram(color = "black", alpha = 0.7) +
  xlab("N50 Value") +
  theme_classic() +
  # scale_fill_npg() +
  scale_fill_manual(
    values = pal_npg("nrc")(3),
    labels = c("JAX don. (Before Cohousing)", 
               "TAC rec. (After Cohousing)", 
               "Tac rec. (Before Cohousing)")
  )
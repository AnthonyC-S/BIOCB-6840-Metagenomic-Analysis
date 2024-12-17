import pandas as pd

# Input file name
input_file = "merged_abundance_table_species.txt"

# Output filtered file name
output_file = "filtered_merged_abundance_table_species.txt"

# Define the selected samples
selected_samples = [
    "seqid_1", "seqid_2", "seqid_3", "seqid_4", "seqid_5", "seqid_6", "seqid_7", "seqid_8", "seqid_9", "seqid_10",
    "seqid_11", "seqid_12", "seqid_13", "seqid_14", "seqid_15", "seqid_16", "seqid_17", "seqid_18", "seqid_19",
    "seqid_20", "seqid_21", "seqid_22", "seqid_23", "seqid_24", "seqid_86", "seqid_87", "seqid_88", "seqid_89",
    "seqid_90"
]

# Step 1: Load the data
try:
    # Assuming the file is tab-separated and the first column is the index
    data = pd.read_csv(input_file, sep="\t", index_col=0)
    print("Data successfully loaded!")
except FileNotFoundError:
    print(f"Error: File '{input_file}' not found!")
    exit()

# Step 2: Filter the data to keep only the selected samples
# Ensure only existing columns are selected
selected_samples = [s for s in selected_samples if s in data.columns]
filtered_data = data[selected_samples]

# Step 3: Save the filtered data to a new file
filtered_data.to_csv(output_file, sep="\t")
print(f"Filtered data saved as '{output_file}'!")

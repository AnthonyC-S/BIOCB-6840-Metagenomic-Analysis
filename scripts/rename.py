import os
import pandas as pd

# Directory containing the files to rename
file_directory = "/home/CALS_BIOCB4840/groupALY/strain3/consensus_markers/"

# Path to the Excel file containing the sequence ID and name mappings
xlsx_file = "/home/CALS_BIOCB4840/groupALY/strain3/sequenced_samples_metadata.xlsx"

# Load the Excel file into a pandas DataFrame
df = pd.read_excel(xlsx_file)

# Loop through each row in the DataFrame
for index, row in df.iterrows():
    seq_id = row['sequence_id']
    real_name = row['name']

    # Find the matching file in the directory
    matching_file = os.path.join(file_directory, f"{seq_id}.json.bz2")
    
    # Check if the file exists
    if os.path.isfile(matching_file):
        # Rename the file to "seq_id_real_name.json.bz2"
        new_name = os.path.join(file_directory, f"{seq_id}_{real_name}.json.bz2")
        os.rename(matching_file, new_name)
        print(f"Renamed {seq_id} to {seq_id}_{real_name}")
    else:
        print(f"File for {seq_id} not found!")

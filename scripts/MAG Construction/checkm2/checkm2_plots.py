import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Define the base path, will need to update.
base_path = "/workdir/taxvamb_output/full_run/filtered_bins"

# Define the custom mapping
custom_mapping = {
    "seqid_1": {"Label": "JAX, Day -7", "Color": "royalblue"},
    "seqid_2": {"Label": "JAX, Day -7", "Color": "royalblue"},
    "seqid_3": {"Label": "JAX, Day -7", "Color": "royalblue"},
    "seqid_4": {"Label": "JAX, Day -7", "Color": "royalblue"},
    "seqid_5": {"Label": "JAX, Day -7", "Color": "royalblue"},
    "seqid_6": {"Label": "JAX, Day -7", "Color": "royalblue"},
    "seqid_13": {"Label": "JAX, Day 0", "Color": "lightsteelblue"},
    "seqid_14": {"Label": "JAX, Day 0", "Color": "lightsteelblue"},
    "seqid_15": {"Label": "JAX, Day 0", "Color": "lightsteelblue"},
    "seqid_16": {"Label": "JAX, Day 0", "Color": "lightsteelblue"},
    "seqid_17": {"Label": "JAX, Day 0", "Color": "lightsteelblue"},
    "seqid_18": {"Label": "JAX, Day 0", "Color": "lightsteelblue"},
    "seqid_10": {"Label": "TAC, Day -7", "Color": "darkorange"},
    "seqid_11": {"Label": "TAC, Day -7", "Color": "darkorange"},
    "seqid_12": {"Label": "TAC, Day -7", "Color": "darkorange"},
    "seqid_7": {"Label": "TAC, Day -7", "Color": "darkorange"},
    "seqid_8": {"Label": "TAC, Day -7", "Color": "darkorange"},
    "seqid_9": {"Label": "TAC, Day -7", "Color": "darkorange"},
    "seqid_19": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_20": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_21": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_22": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_23": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_24": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_86": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_87": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_88": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_89": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_90": {"Label": "TAC, Day 0", "Color": "navajowhite"},
    "seqid_75": {"Label": "TAC, Day 38, Control, Untreated", "Color": "lightgreen"},
    "seqid_76": {"Label": "TAC, Day 38, Control, Treated", "Color": "forestgreen"},
    "seqid_77": {"Label": "TAC, Day 38, Treated, Housed with Treated JAX", "Color": "darkviolet"},
    "seqid_78": {"Label": "TAC, Day 38, Treated, Housed with Untreated JAX", "Color": "violet"},
    "seqid_79": {"Label": "TAC, Day 38, Treated, Housed with Treated JAX", "Color": "darkviolet"},
    "seqid_80": {"Label": "TAC, Day 38, Treated, Housed with Untreated JAX", "Color": "violet"},
    "seqid_81": {"Label": "TAC, Day 38, Control, Untreated", "Color": "lightgreen"},
    "seqid_82": {"Label": "TAC, Day 38, Treated, Housed with Untreated JAX", "Color": "violet"},
    "seqid_83": {"Label": "TAC, Day 38, Treated, Housed with Treated JAX", "Color": "darkviolet"},
    "seqid_84": {"Label": "TAC, Day 38, Untreated, Housed with Untreated JAX", "Color": "yellow"},
    "seqid_85": {"Label": "TAC, Day 38, Control, Treated", "Color": "forestgreen"},
}

# Initialize an empty list to store DataFrames
dataframes = []

# Walk through the directories to find all quality_report.tsv files
for root, dirs, files in os.walk(base_path):
    for file in files:
        if file == "quality_report.tsv":
            # Extract seqid_# from the directory path
            seqid = os.path.basename(os.path.dirname(root))
            
            # Read the quality_report.tsv file into a DataFrame
            file_path = os.path.join(root, file)
            df = pd.read_csv(file_path, sep="\t")
            
            # Add seqid_# as a column
            df["SeqID"] = seqid
            
            # Append the DataFrame to the list
            dataframes.append(df)

# Combine all DataFrames into one
combined_df = pd.concat(dataframes, ignore_index=True)

# Map custom labels and colors based on SeqID
combined_df["Label"] = combined_df["SeqID"].map(lambda x: custom_mapping[x]["Label"] if x in custom_mapping else None)
combined_df["Color"] = combined_df["SeqID"].map(lambda x: custom_mapping[x]["Color"] if x in custom_mapping else None)

# Drop rows with missing labels (optional)
combined_df = combined_df.dropna(subset=["Label"])


def plot_scatter():
    # Create a scatter plot using Matplotlib
    plt.figure(figsize=(12, 8))

    # Plot each group separately to apply custom colors
    for label in combined_df["Label"].unique():
        group_data = combined_df[combined_df["Label"] == label]
        plt.scatter(
            group_data["Completeness"],
            group_data["Contamination"],
            label=label,
            color=group_data["Color"].iloc[0],  # Use the first color in the group (consistent within a group)
            s=25,
            alpha=0.8,
        )

    # Customize plot appearance
    plt.title("CheckM2 Contamination vs. Completeness of MAGs", fontsize=16)
    plt.xscale
    plt.xlabel("Completeness (%)", fontsize=14)
    plt.ylabel("Contamination (%)", fontsize=14)

    legend_order = ["JAX, Day -7", "JAX, Day 0", "TAC, Day -7", "TAC, Day 0", "TAC, Day 38, Control, Treated",
                    "TAC, Day 38, Control, Untreated", "TAC, Day 38, Untreated, Housed with Untreated JAX",
                    "TAC, Day 38, Treated, Housed with Treated JAX", "TAC, Day 38, Treated, Housed with Untreated JAX"
                    ]


    # Get current legend handles and labels
    handles, labels = plt.gca().get_legend_handles_labels()
    # Reorder legend
    if legend_order:
        ordered_handles = [handles[labels.index(group)] for group in legend_order if group in labels]
        ordered_labels = [group for group in legend_order if group in labels]
        plt.legend(ordered_handles, ordered_labels, title="Groups", loc='best')

    # Restrict x-axis and y-axis ranges. Use if you want a better plot of near-complete MAGs.
    # plt.xlim(80, 100)  # Completeness: 80% to 100%
    # plt.ylim(0, 10)    # Contamination: 0% to 10%

    plt.legend(title="Sample Groups", loc='upper left', fontsize=10)
    plt.grid(True, linestyle="--", alpha=0.6)
    plt.tight_layout()

    # Show the plot
    plt.savefig(dpi=500, fname="taxvamb_checkm2_quality_smaller_scatterplot_TEST.png")
    plt.show()


def plot_heatmap():
    # Bin Completeness and Contamination into ranges (e.g., every 5%)
    completeness_bins = np.arange(0, 105, 5)  # Completeness bins: 0-100% (every 5%)
    contamination_bins = np.arange(0, 105, 5)  # Contamination bins: 0-100% (every 5%)

    combined_df["Completeness_Bin"] = pd.cut(combined_df["Completeness"], bins=completeness_bins, right=False)
    combined_df["Contamination_Bin"] = pd.cut(combined_df["Contamination"], bins=contamination_bins, right=False)

    # Create a pivot table to count the number of MAGs in each bin
    heatmap_data = combined_df.pivot_table(
        index="Contamination_Bin",
        columns="Completeness_Bin",
        values="Name",  # Use any column to count rows (e.g., Name)
        aggfunc="count",
        fill_value=0,
    )

    # Plot the heatmap using Seaborn with origin='lower'
    plt.figure(figsize=(12, 10))
    ax = sns.heatmap(
        heatmap_data,
        annot=True,
        fmt="d",
        cmap="viridis",
        cbar_kws={"label": "Number of MAGs"},
        square=True,
        linewidths=0.5,
        linecolor='gray',
    )

    ax.invert_yaxis()

    # Customize plot appearance
    plt.title("Heatmap of MAG Counts by Completeness and Contamination Bins", fontsize=16)
    plt.xlabel("Completeness (%)", fontsize=14)
    plt.ylabel("Contamination (%)", fontsize=14)

    # Adjust x-axis and y-axis tick labels to show bin ranges clearly
    plt.xticks(
        np.arange(len(heatmap_data.columns)) + 0.5,
        [f"{int(interval.left)}-{int(interval.right)}%" for interval in heatmap_data.columns],
        rotation=45,
    )
    plt.yticks(
        np.arange(len(heatmap_data.index)) + 0.5,
        [f"{int(interval.left)}-{int(interval.right)}%" for interval in heatmap_data.index],
    )

    plt.tight_layout()
    plt.savefig(dpi=500, fname='taxvamb_checkm2_quality_heatmap_TEST.png')
    plt.show()

plot_scatter()
plot_heatmap()
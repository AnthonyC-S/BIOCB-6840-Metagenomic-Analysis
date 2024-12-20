import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from scipy.cluster.hierarchy import linkage
from sklearn.decomposition import PCA
from adjustText import adjust_text


# Activate conda env sourmash_plot.


def plot_heatmap_with_colors(matrix, labels, title, custom_mapping):
    # Perform hierarchical clustering
    linkage_matrix = linkage(matrix, method='average')

    # Generate color lists for row and column labels
    row_colors = [custom_mapping[label]["Color"] for label in labels]
    col_colors = row_colors  # Assuming same order for rows and columns

    # Create clustermap
    g = sns.clustermap(
        matrix,
        row_linkage=linkage_matrix,
        col_linkage=linkage_matrix,
        xticklabels=labels,
        yticklabels=labels,
        row_colors=row_colors,
        col_colors=col_colors,
        cmap="viridis",
        figsize=(12, 10),
        cbar_pos=(1.01, 0.32, 0.03, 0.2) # Move color bar to below legend
    )

    # Add a title
    g.figure.suptitle(title, y=1.03, x=0.7, ha='center', fontsize=18)

    # Create a legend
    unique_labels = {v["Label"]: v["Color"] for v in custom_mapping.values()}
    legend_patches = [mpatches.Patch(color=color, label=label) for label, color in unique_labels.items()]
    g.ax_heatmap.legend(
        handles=legend_patches,
        loc='upper left',
        bbox_to_anchor=(1.09, 1),  # Move legend outside the heatmap
        frameon=False,
        title="Legend"
    )

    # Save the figure
    g.savefig(f"{title}.png", dpi=500)
    plt.show()


def plot_pca(similarity_matrix, seqid_labels, custom_mapping, title, legend_order=None):
    # Perform PCA
    pca = PCA(n_components=2)
    pca_results = pca.fit_transform(similarity_matrix)
    # Create PCA plot
    plt.figure(figsize=(15, 10))
    texts = []  # To store label text objects for adjustText
    for i, seqid in enumerate(seqid_labels):
        label = custom_mapping[seqid]["Label"]
        color = custom_mapping[seqid]["Color"]
        plt.scatter(
            pca_results[i, 0],
            pca_results[i, 1],
            label=label if label not in plt.gca().get_legend_handles_labels()[1] else None,
            color=color,
            alpha=1,
            s=120
        )
        # Add labels
        texts.append(plt.text(
            pca_results[i, 0],
            pca_results[i, 1],
            seqid,
            fontsize=8
        ))
    # Adjust text to prevent overlap
    adjust_text(
        texts,
        expand=(1.4, 2),
        arrowprops=dict(arrowstyle='->', color='gray', lw=1)
    )
    # Get current legend handles and labels
    handles, labels = plt.gca().get_legend_handles_labels()
    # Reorder legend
    if legend_order:
        ordered_handles = [handles[labels.index(group)] for group in legend_order if group in labels]
        ordered_labels = [group for group in legend_order if group in labels]
        plt.legend(ordered_handles, ordered_labels, title="Groups", loc='best')

    plt.title(title)
    plt.xlabel(f"PC1 ({pca.explained_variance_ratio_[0] * 100:.2f}% variance)")
    plt.ylabel(f"PC2 ({pca.explained_variance_ratio_[1] * 100:.2f}% variance)")
    plt.grid(False)
    plt.tight_layout()

    # Show and save plot
    plt.savefig(dpi=500, fname=title + '.png')
    plt.show()

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

legend_order = ["JAX, Day -7", "JAX, Day 0", "TAC, Day -7", "TAC, Day 0", "TAC, Day 38, Control, Treated",
                "TAC, Day 38, Control, Untreated", "TAC, Day 38, Untreated, Housed with Untreated JAX",
                "TAC, Day 38, Treated, Housed with Treated JAX", "TAC, Day 38, Treated, Housed with Untreated JAX"
                ]

matrix_dir = "/path/to/dir/sourmash_scaled-1000_k-31/comparison_matrix"

# Jaccard Index Matrix
matrix = np.load(matrix_dir + "/compare_all_matrix.npy")
with open(matrix_dir + "/compare_all_matrix.npy.labels.txt", 'r') as file:
    labels = [line.strip() for line in file]

# Plot Jaccard PCA
title_pca = "PCA Plot - Sourmash Jaccard Index (scaled 1000, kmer 31)"
plot_pca(matrix, labels, custom_mapping, title_pca, legend_order)

# Plot Jaccard Heatmap
title_heatmap = "Metagenome Clustering Heatmap - Sourmash with Jaccard Indexing Similarity (scaled 1000, kmer 31)"
plot_heatmap_with_colors(matrix, labels, title_heatmap, custom_mapping)

# ANI Matrix
matrix_ani = np.load(matrix_dir + "/compare_all_matrix_ani.npy")
with open(matrix_dir + "/compare_all_matrix_ani.npy.labels.txt", 'r') as file:
    labels_ani = [line.strip() for line in file]

# Plot ANI PCA
title_pca_ani = "PCA Plot - Sourmash ANI (scaled 1000, kmer 31)"
plot_pca(matrix_ani, labels_ani, custom_mapping, title_pca_ani, legend_order)

# Plot ANI heatmap
ani_title_heatmap = "Metagenome Clustering Heatmap - Sourmash with ANI Similarity (scaled 1000, kmer 31)"
plot_heatmap_with_colors(matrix_ani, labels_ani, ani_title_heatmap, custom_mapping)
# Create necessary directories
mkdir -p sams
mkdir -p bowtie2
mkdir -p profiles

# Loop over all seqid folders in the three specified directories, may need to alter paths.
for dir in /workdir/reads_postqc/before_treatment/TAC/seqid_* \
          /workdir/reads_postqc/before_treatment/JAX/seqid_* \
          /workdir/reads_postqc/after_cohousing/TAC/seqid_*; do
    # Extract the seqid number from the folder name
    seqid=$(basename ${dir})

    # Define the input files based on seqid
    f1="${dir}/${seqid}.trim_1.fastq"
    f2="${dir}/${seqid}.trim_2.fastq"

    # Check if both input files exist
    if [[ -f ${f1} && -f ${f2} ]]; then
        # Get the base name by removing the '.trim_1.fastq' part
        bn=$(basename ${f1} .trim_1.fastq)

        # Run MetaPhlAn for this pair of fastq files
        echo "Running MetaPhlAn on ${f1} and ${f2}"
        metaphlan ${f1},${f2} --input_type fastq \
            -s sams/${bn}.sam.bz2 \
            --bowtie2out bowtie2/${bn}.bowtie2.bz2 \
            -o profiles/${bn}_profiled.tsv --nproc 6
    else
        echo "Warning: Missing paired FASTQ files for ${seqid}. Skipping..."
    fi
done



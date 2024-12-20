# path to fastq data files and path to metaspades package in biohpc
directory="/workdir/abx_recovery_metagenomics/processed_data"

# Used SPAdes version 4.0.0, can be downloaded here: https://ablab.github.io/spades/installation.html
spades_package="/programs/spades/bin/spades.py"

# for loop to execute metaspades for all sequence ID folders in the base directory folder
for seqid in $(ls "$directory"); do
    input_dir="${directory}/${seqid}"
    output_dir="${input_dir}/spades_output"

    # confirm whether the right input files for metaspades exist in the sequence ID folder
    if [[ -f "${input_dir}/${seqid}.trim_1.fastq" && -f "${input_dir}/${seqid}.trim_2.fastq" && \
          -f "${input_dir}/${seqid}.singleton_1.fastq" && -f "${input_dir}/${seqid}.singleton_2.fastq" ]]; then

        # run metaspades
        $spades_package --meta \
            --pe-1 1 "${input_dir}/${seqid}.trim_1.fastq" \
            --pe-2 1 "${input_dir}/${seqid}.trim_2.fastq" \
            --pe-s 1 "${input_dir}/${seqid}.singleton_1.fastq" \
            --pe-s 1 "${input_dir}/${seqid}.singleton_2.fastq" \
            -k 21,33,55,77 \
            -t 50 \
            -m 125 \
            -o "${output_dir}"

        echo "successfully completed metaspades for ${seqid}"
    else
        echo "unable to locate fastq file(s) in ${seqid}"
    fi
done

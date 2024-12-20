
mkdir -p outputdiff
strainphlan -s consensus_markers/seqid_{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,86,87,88,89,90}.json.bz2 \
    -m db_markers2/t__SGB7041.fna \
    -r GCA_000159355.1_ASM15935v1_genomic.fna \
    -o outputdiff \
    -n 16 \
    -c t__SGB7041 \
    --mutation_rates


mkdir -p output
strainphlan -s consensus_markers/*.json.bz2 -m db_markers/t__SGB7041.fna -r <reference genome> -o output -n 8 -c t__SGB7041 --mutation_rates 

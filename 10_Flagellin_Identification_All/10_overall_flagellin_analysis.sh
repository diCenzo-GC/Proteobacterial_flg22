# Collect the proteins
cat ../*Flagellin*/FlagellinProteins/Flagellin_all.faa > Flagellin_all.faa

# Alignments
clustalo --threads=4 -i Flagellin_all.faa -o alignment_output.fasta
trimal -in alignment_output.fasta -out final_flagellin_alignment.fasta -fasta -automated1

# Make phylogeny - done on the Compute Canada Graham server
sbatch makePhylogeny.sh # Make the phylogeny with RAxML with 16 parallel processes each using 4 threads

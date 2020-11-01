# Make directories
mkdir Reannotate_genomes/ # Make directory
mkdir Genome_files/ # Make directory
mkdir Proteomes/ # Make directory
mkdir MarkerScannerOutput/ # Make directory
mkdir MarkerScannerSingle/ # Make directory
mkdir MarkerScannerCounted/ # Make directory
mkdir MarkerScannerGood/ # Make directory
mkdir Mafft/ # Make directory
mkdir Trimal/ # Make directory
mkdir TrimalModified/ # Make directory
mkdir Phylogeny/ # Make directory

# Download genomes
perl Scripts/parseGenomeList.pl Input_files/Gammaproteobacteria.csv  # Parse the NCBI genome table to get info to download genomes
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/sp._/sp_/' Input_files/genomeList.txt # Fix sp._ to sp_
sort -u -k1,1 Input_files/genomeList.txt > temp.txt # Remove duplicates- save it as a temp file
mv temp.txt Input_files/genomeList.txt # Rename the file - cuz we can’t rewrite/ re-save it directly
# Manually fix issues with species names
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # download the genomes of interest

# Get the marker proteins - extract them
perl Scripts/switchNames.pl # Switch protein names
cat Proteomes/*.faa > combined_proteomes.faa # Combine the faa files into one file
rm Proteomes/*.faa # Remove unneeded files
perl Scripts/updateNumber.pl ~/Bioinformatics_Programs/AMPHORA2/Scripts/MarkerScanner.pl # updates the number of sequences in the MarkerScanner.pl script
perl Scripts/MarkerScanner.pl -Bacteria combined_proteomes.faa # perform the MarkerScanner analysis
mv *.pep MarkerScannerOutput/ # Move output of MarkerScanner output directory
perl Scripts/extractSingle.pl # Extract proteins that are single copy (if the protein appears twice - we just want one)
perl Scripts/countProteins.pl # Check that the proteins are found in enough genomes
perl Scripts/checkSpecies.pl # Check that in those genomes, the protein is found in single copy (probably redundant since the addition of extractSingle.pl)

# Run alignments and prepare concatenated alignment
perl Scripts/align_trim.pl # Run mafft on all individual sets of proteins
perl Scripts/modifyTrimAl.pl # Modify the trimAl output to prepare it for combining the alignments
perl Scripts/sortProteins.pl # Sort each of the trimAl output files that will be used for further analysis
perl Scripts/combineAlignments.pl > Phylogeny/MLSA_final_alignment.fasta # Concatenate the alignment files
# Make phylogeny on CIPRES

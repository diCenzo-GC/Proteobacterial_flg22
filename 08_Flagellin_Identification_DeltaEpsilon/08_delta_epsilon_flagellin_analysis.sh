# Prepare directories
mkdir Genome_files/ # Make directory
mkdir hmmDatabaseFiles/ # Make directory
mkdir HMMsearch/ # Make directory
mkdir HMMsearchParsed/ # Make directory
mkdir HMMsearchHits/ # Make directory
mkdir HMMscan/ # Make directory
mkdir HMMscanParsed/ # Make directory
mkdir HMMscanTop/ # Make directory
mkdir HMMscanTopLists/ # Make directory
mkdir SymbioticProteins/ # Make directory
mkdir Extraction/ # Make directory
mkdir Motif/  # Make directory

# Download genomes
perl Scripts/parseGenomeList.pl Input_files/Delta_Epsilon_proteobacteria.csv # Parse the NCBI genome table to get info to download genomes
sed -i 's/__/_/g' Input_files/genomeList.txt # Fix the double __
sed -i 's/sp._/sp_/' Input_files/genomeList.txt # Fix sp._ to sp_
sort -u -k1,1 Input_files/genomeList.txt > temp.txt # Remove duplicates- save it as a temp file
mv temp.txt Input_files/genomeList.txt # Rename the file - cuz we can’t rewrite/ re-save it directly
# Manually fix issues with species names
perl Scripts/downloadGenomes.pl Input_files/genomeList.txt # download the genomes of interest

# Extract protein sequences
perl Scripts/extractFaaFromGBFF.pl # Make faa files from the GenBank files
perl Scripts/modifyFasta.pl combined_proteomes_HMM.faa > combined_proteomes_HMM_modified.faa # Modify the fasta file for easy extraction

# Download HMM databases
wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/releases/Pfam33.1/Pfam-A.hmm.gz # get the Pfam HMM files
wget ftp://ftp.jcvi.org/pub/data/TIGRFAMs//TIGRFAMs_15.0_HMM.LIB.gz # get the TIGRFAM HMM files
wget https://ftp.ncbi.nih.gov/pub/mmdb/cdd/fasta.tar.gz # Download CDD database
tar -xzf fasta.tar.gz # Unzip CDD database
mv PRK06008.FASTA hmmDatabaseFiles/ # Move file
mv PRK12687.FASTA hmmDatabaseFiles/ # Move file
rm *.FASTA # Remove unwanted files
mv fasta.tar.gz hmmDatabaseFiles/ # Move file
hmmbuild hmmDatabaseFiles/PRK06008.hmm hmmDatabaseFiles/PRK06008.FASTA
hmmbuild hmmDatabaseFiles/PRK12687.hmm hmmDatabaseFiles/PRK12687.FASTA
gunzip Pfam-A.hmm.gz # unzip the Pfam files
gunzip TIGRFAMs_15.0_HMM.LIB.gz # unzip the TIGRFAM files
mv Pfam-A.hmm hmmDatabaseFiles/Pfam-A.hmm # move the Pfam files
mv TIGRFAMs_15.0_HMM.LIB hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB # move the TIGRFAM files
hmmconvert hmmDatabaseFiles/Pfam-A.hmm > hmmDatabaseFiles/Pfam-A_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/TIGRFAMs_15.0_HMM.LIB > hmmDatabaseFiles/TIGRFAM_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/PRK06008.hmm > hmmDatabaseFiles/PRK06008_converted.hmm # convert the database to the necessary format
hmmconvert hmmDatabaseFiles/PRK12687.hmm > hmmDatabaseFiles/PRK12687_converted.hmm # convert the database to the necessary format
cat hmmDatabaseFiles/Pfam-A_converted.hmm hmmDatabaseFiles/TIGRFAM_converted.hmm hmmDatabaseFiles/PRK06008_converted.hmm hmmDatabaseFiles/PRK12687_converted.hmm > hmmDatabaseFiles/converted_combined.hmm # combined all hidden Markov models into a single file
hmmpress hmmDatabaseFiles/converted_combined.hmm # prepare files for hmmscan searches

# Perform the HMMsearch screens
perl Scripts/performHMMsearch.pl # A short script to repeat for all HMM files, the build, hmmsearch, parsing, and hit extraction

# Perform the HMM scan screens
perl Scripts/performHMMscan.pl # A short script to repeat for all the HMM search output files, to perform hmmscan, parse, and hit extraction
gzip -r hmmDatabaseFiles/ # Compress files

# Determine strains with each protein
perl Scripts/determineProteinPresence.pl > Flagellin_distribution.txt # determine which of the six proteins are in each of the strains

# Extract proteins
perl Scripts/extractHMMscanHits.pl # extract all the Flagellin proteins

# Alignments
clustalo --threads=4 -i FlagellinProteins/Flagellin_all.faa -o alignment_output
perl Scripts/modifyFasta.pl alignment_output > Extraction/alignment_final
# flg22 in Arcobacter_anaerophilus should be EKLSSGL-RINK---------AADD-----AS--GLAIA - found to be at 48 to 86 character

# Extracting the flg22 sequence from each species
cd Extraction/
cut -f1 -d$'\t' alignment_final > name #take out the 1st column (the species name) into a new file
cut -f2 -d$'\t' alignment_final > sequence #take out the 2nd column (the sequence) into a new file
cut -c 85-115 sequence > flg22 #take out the flg22 sequence which is located at character number 85 to 115
paste name flg22 > final #merging them back together
# Manually inspect and remove incomplete sequences in excel, remove gaps, then uploaded it back as tab denim file final_flg22_clean.txt
awk '{print $1"\n"$2}' final_flg22_clean.txt > Flg22_sequences_final.txt #so that the name and the sequence are interleaved
cut -f1 -d$'\t' final_flg22_clean.txt > name
cut -f2 -d$'\t' final_flg22_clean.txt > flg22
sed 's/__.*//' name > species #take out everything before the first _ _ to a new file
paste species flg22 > SpeciesAndFlg22 #flg22 was extracted before
sort -u -k1,1 SpeciesAndFlg22 > Unique #only has one for every species
cd ..

#Extracting species with the specific sequence we identified to be active flg22
grep '[ST]..[DN][DN].AG..I' Extraction/final_flg22_clean.txt | cut -f1 | sed 's/__/ /' | cut -f1 -d' ' | sed 's/>//' | sort -u > Motif/wMotif #put it into a document

# Look for ones with flagellin but not this specific motif
# Flagellin_distribution.txt is a file that indicates presence of flagellin with 1 and 0
awk '{
 if ($2 == 1)
 print $1
 }' Flagellin_distribution.txt > Motif/wFlagellin #take out ones with flagellin
awk '{
 if ($2 == 0)
 print $1
 }' Flagellin_distribution.txt > Motif/withoutFlagellin #take out ones without flagellin
 grep -v -f Motif/wMotif Motif/wFlagellin > Motif/withoutMotif #take out ones that are in wFlagellin but not in wMotif, should be less
 grep '[ST]..[DE][DE].AG' Extraction/Unique | cut -f1 | sed 's/__/ /' | cut -f1 -d' ' | sed 's/>//' | sort -u > Motif/wMotif_2 #put it into a file #second motif

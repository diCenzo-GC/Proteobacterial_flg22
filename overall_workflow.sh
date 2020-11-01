# Make phylogeny of the Alphaproteobacteria
cd 01_MLSA_Phylogeny_Alpha
sh 01_alphaproteobacteria_MLSA_pipeline.sh
cd ..

# Analysis of the flagellin of the Alphaproteobacteria
cd 02_Flagellin_Identification_Alpha
sh 02_alpha_flagellin_analysis.sh
cd ..

# Make phylogeny of the Gammaproteobacteria
cd 03_MLSA_Phylogeny_Gamma
sh 03_gammaproteobacteria_MLSA_pipeline.sh
cd ..

# Analysis of the flagellin of the Gammaproteobacteria
cd 04_Flagellin_Identification_Gamma
sh 04_gamma_flagellin_analysis.sh
cd ..

# Make phylogeny of the Betaproteobacteria
cd 05_MLSA_Phylogeny_Beta
sh 05_betaproteobacteria_MLSA_pipeline.sh
cd ..

# Analysis of the flagellin of the Betaproteobacteria
cd 06_Flagellin_Identification_Beta
sh 06_beta_flagellin_analysis.sh
cd ..

# Make phylogeny of the Deltaproteobacteria and the Epsilonproteobacteria
cd 07_MLSA_Phylogeny_DeltaEpsilon
sh 07_delta_epsilonproteobacteria_MLSA_pipeline.sh
cd ..

# Analysis of the flagellin of the Betaproteobacteria
cd 08_Flagellin_Identification_DeltaEpsilon
sh 08_delta_epsilon_flagellin_analysis.sh
cd ..

# Make an overall phylogeny of the Proteobacteria
cd 09_MLSA_Phylogeny_All
sh 09_proteobacterium_MLSA_pipeline.sh
cd ..

# Analysis of the flagellin of the Proteobacteria
cd 10_Flagellin_Identification_All
sh 10_overall_flagellin_analysis.sh
cd ..

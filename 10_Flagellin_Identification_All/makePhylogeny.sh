#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-gd38
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=2G
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun ~/projects/def-gd38/gd38/RAxML/standard-RAxML/raxmlHPC-HYBRID-AVX -T 4 -s final_flagellin_alignment.fasta -N autoMRE -n Flagellin_phylogeny -f a -p 12345 -x 12345 -m PROTCATLG

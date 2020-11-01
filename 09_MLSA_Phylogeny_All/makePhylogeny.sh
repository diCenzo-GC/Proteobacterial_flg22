#!/bin/bash
#SBATCH --time=48:00:00
#SBATCH --account=def-gd38
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=3G
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
srun ~/projects/def-gd38/gd38/RAxML/standard-RAxML/raxmlHPC-HYBRID-AVX -T 16 -s MLSA_final_alignment.fasta -N 100 -n MLSA_phylogeny -f a -p 12345 -x 12345 -m PROTCATLG

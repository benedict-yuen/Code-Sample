#!/bin/bash

#SBATCH --job-name=mafft
#SBATCH --partition=medium
#SBATCH --cpus-per-task=24
#SBATCH --mem=10gb
#SBATCH --output=slurm-%j-mafft.out
#SBATCH --error=slurm-%j-mafft.err
#SBATCH --time=6:00:00 


# Load required module
module load mafft/7.304

# Define input and output paths
INPUT_XMFA="core_mauve_aln.xmfa"
OUTPUT_FASTA="core_mauve_aln_cat.fa"
OUTPUT_MAFFTED="core_mauve_aln_cat_maffted.fa"

# Define helper script path
XMFA2FASTA_SCRIPT="/scratch/projects/eei/software/xmfa2fasta.pl"

# Convert XMFA to FASTA format
echo "Converting XMFA to FASTA..."
perl /scratch/projects/eei/software/xmfa2fasta.pl --align --file "$INPUT_XMFA" > "$OUTPUT_FASTA"

# Perform multiple sequence alignment using MAFFT
echo "Performing MAFFT alignment..."
mafft --auto --thread $SLURM_CPUS_PER_TASK "$OUTPUT_FASTA" > "$OUTPUT_MAFFTED"

#!/bin/bash

#SBATCH --job-name=trimtree
#SBATCH --partition=medium
#SBATCH --cpus-per-task=1
#SBATCH --mem=80gb
#SBATCH --output=slurm-%j-fastree.out
#SBATCH --error=slurm-%j-fastree.err
#SBATCH --time=07:00:00 

# Load Anaconda
module load anaconda3
source $ANACONDA3_ROOT/etc/profile.d/conda.sh 

# Define input and output filenames
INPUT_FA="core_mauve_aln_cat_maffted.fa"
OUTPUT_FA_TRIM="core_mauve_aln_cat_maffted_trim.fa"
OUTPUT_HTML="core_mauve_aln_cat_maffted075080.html"
OUTPUT_TREE="core_mauve_aln_cat_maffted_trim_FastTree.tre"

############ Trimming ############

echo "Trimming alignment..."

# Activate the 'trimal' conda environment
conda activate trimal

# Run trimal for alignment trimming
trimal -in "$INPUT_FA" -out "$OUTPUT_FA_TRIM" -htmlout "$OUTPUT_HTML" -resoverlap 0.75 -seqoverlap 80

# Deactivate the 'trimal' conda environment
conda deactivate

############ Tree Building ############

echo "Building phylogenetic tree..."

# Activate the 'fasttree' conda environment
conda activate fasttree

# Run FastTree for tree construction
FastTree -gtr -nt < "$OUTPUT_FA_TRIM" > "$OUTPUT_TREE"

# Deactivate the 'fasttree' conda environment
conda deactivate

#!/bin/bash

#SBATCH --job-name=mauve
#SBATCH --mail-type=ALL
#SBATCH --partition=medium
#SBATCH --cpus-per-task=1
#SBATCH --mem=100gb
#SBATCH --output=mauve_%j.out
#SBATCH --error=mauve_%j.err
#SBATCH --time=24:00:00 
#SBATCH -C scratch    

#run sbatch script.sh in working directory that contains a subdirectory ($PWD/genomes) with fasta files ending in.fa

# Load Anaconda and activate environment
module load anaconda3
source $ANACONDA3_ROOT/etc/profile.d/conda.sh 
conda activate mauve

# Define input and output paths
GENOMES_DIR="$PWD/genomes"
OUTPUT_DIR="$PWD"

# Define output file names
ALIGNMENT_OUTPUT="mauve_aln.xmfa"
GUIDE_TREE_OUTPUT="mauve_aln.tree"
BACKBONE_OUTPUT="mauve_aln.backbone"
CORE_GENES_OUTPUT="core_mauve_aln.xmfa"

# Print informative messages
echo "Aligning genomes..."
# Run progressiveMauve
progressiveMauve \
    --output="$OUTPUT_DIR/$ALIGNMENT_OUTPUT" \
    --output-guide-tree="$OUTPUT_DIR/$GUIDE_TREE_OUTPUT" \
    --backbone-output="$OUTPUT_DIR/$BACKBONE_OUTPUT" \
    "$GENOMES_DIR"/*fa

echo "Extracting core genes..."
# Determine the number of genome files
NUM_GENOMES=$(ls "$GENOMES_DIR"/*.fa | wc -l)
# Run stripSubsetLCBs
stripSubsetLCBs "$ALIGNMENT_OUTPUT" "$ALIGNMENT_OUTPUT.bbcols" \
    "$CORE_GENES_OUTPUT" 500 "$NUM_GENOMES"



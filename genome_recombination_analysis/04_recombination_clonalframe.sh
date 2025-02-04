#!/bin/bash

#SBATCH --job-name=clonalframe
#SBATCH --partition=medium
#SBATCH --cpus-per-task=1
#SBATCH --mem=100gb
#SBATCH --output=slurm-%j-clonalframe.out
#SBATCH --error=slurm-%j-clonalframe.err
#SBATCH --time=24:00:00 

# Load Anaconda
module load anaconda3
source $ANACONDA3_ROOT/etc/profile.d/conda.sh 
conda activate clonalframeml
#R script for summarising/visualising the results is from https://github.com/xavierdidelot/ClonalFrameML/blob/master/src/cfml_results.R

# Define input and output filenames
INPUT_TREE="core_mauve_aln_cat_maffted_trim_FastTree.tre"
INPUT_FA_TRIM="core_mauve_aln_cat_maffted_trim.fa"
OUTPUT_PREFIX="clonalframe_embranch"

# Define helper script path 
CFML_RESULTS="/scratch/projects/eei/software/clonalframeml/cfml_results.R"


# Run ClonalFrameML for branch estimation
#echo "Running ClonalFrameML for branch estimation..."
ClonalFrameML "$INPUT_TREE" "$INPUT_FA_TRIM" "$OUTPUT_PREFIX" -emsim 100


# Run R script for processing ClonalFrameML results
echo "Processing ClonalFrameML results..."
Rscript "$CFML_RESULTS" "$OUTPUT_PREFIX"

# Deactivate the 'clonalframeml' conda environment
conda deactivate

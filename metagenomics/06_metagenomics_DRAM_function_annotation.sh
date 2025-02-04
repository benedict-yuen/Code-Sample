#!/bin/bash
#
#SBATCH --job-name DRAM_annotate
#SBATCH --cpus-per-task=24
#SBATCH --mem=150GB
#SBATCH --output=DRAM_annotate-%j.out
#SBATCH --error=DRAM_annotate-%j.err
#SBATCH --partition=medium
#SBATCH --time=7:00:00
 
#sbatch .sh genome.fasta
#one 4.5mb sized genome takes about 6h.

module load anaconda3

source $ANACONDA3_ROOT/etc/profile.d/conda.sh
conda activate DRAM

GENOME=$1

DRAM.py annotate --use_uniref --threads $SLURM_CPUS_PER_TASK -i $1 -o $TMP_SCRATCH/${GENOME%%.fa}_DRAM_uniref

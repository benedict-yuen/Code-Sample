#!/bin/bash
#
#SBATCH --job-name checkm2
#SBATCH --cpus-per-task=30
#SBATCH --mem=50GB
#SBATCH --output=checkm2-%j.out
#SBATCH --error=checkm2-%j.err
#SBATCH --partition=medium
#SBATCH --time=8:00:00 

###usage###
#sbatch .sh 
#run in directory containing the final MAGs

WD=$PWD

module load anaconda3
source $ANACONDA3_ROOT/etc/profile.d/conda.sh
conda activate checkm2

mkdir $WD/checkm2_out
checkm2 predict -x fa --threads $SLURM_CPUS_PER_TASK --input $WD --output-directory $WD/checkm2_out

#--force forces the output into the working directory. I just wanted to avoid making a new folder...we'll see if I regret this
#I totally regret this.. it deletes everything...

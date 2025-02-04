#!/bin/bash
#SBATCH --job-name=spades                     
#SBATCH --mail-type=FAIL                         
#SBATCH --mail-user=byuen@mpi-bremen.de          
#SBATCH --ntasks=1                              
#SBATCH --cpus-per-task=24
#SBATCH --mem=400GB                            
#SBATCH --time=36:00:00                         
#SBATCH --output=spades_%j_slurm.out
#SBATCH --error=spades_%j_slurm.err
#SBATCH --partition=medium
#SBATCH -C scratch    

#internal variables of memory and threads must be set inside
#sbatch .sh <READS.FQ> <OUTDIR>


module load spades
WD="$(pwd)"

rsync -v -L $1 $TMP_SCRATCH

spades.py -t $SLURM_CPUS_PER_TASK -m 500 -k 21,31,41,51,61,71,81,91 --tmp-dir $TMP_SCRATCH --meta --pe1-12 $TMP_SCRATCH/$1 -o $TMP_SCRATCH/$2

mkdir $WD/$2
mkdir $WD/$2/scaff

rsync -r $TMP_SCRATCH/$2/scaffolds.fasta $WD/$2/scaff/

rsync -r $TMP_SCRATCH/$2/spades.log $WD/$2/

rm -r $TMP_SCRATCH/*


#!/bin/bash
#
#SBATCH --job-name=MitoZ                
#SBATCH --mail-type=FAIL   
#SBATCH --cpus-per-task=16
#SBATCH --mem=100gb
#SBATCH --time=03:30:00  
#SBATCH -C scratch
#SBATCH -p medium
#SBATCH  --output=mitoZ_slurm_%j.log


### usage ###
#sbatch 01_mitoz.sh READS_Interleaved 
#run in directory containing the reads

#Split interleaved reads
module load bbmap

rsync -v -L $1 $TMP_SCRATCH
pigz -d -p 16 $TMP_SCRATCH/$1

reformat.sh in1=$TMP_SCRATCH/${1} out1=$TMP_SCRATCH/${1%%.*}_R1.fastq  out2=$TMP_SCRATCH/${1%%.*}_R2.fastq

#Make output directory
mkdir $PWD/${1%%.*}_mitoz

#Move split read pairs into output directory
rsync -v -L $TMP_SCRATCH/*_R*fastq $PWD/${1%%.*}_mitoz

module purge


module load singularity

singularity exec -B $PWD \
~/Software/MitoZ_v3.4.sif \
mitoz all \
--workdir $PWD/${1%%.*}_mitoz \
--outprefix ${1%%.*} \
--thread_number 16 \
--clade Mollusca \
--genetic_code auto \
--fq1 $PWD/${1%%.*}_mitoz/${1%%.*}_R1.fastq \
--fq2 $PWD/${1%%.*}_mitoz/${1%%.*}_R2.fastq \
--fastq_read_length 151 \
--data_size_for_mt_assembly 0 \
--assembler megahit \
--kmers_megahit 59 79 99 119 141 \
--memory 100 \
--requiring_taxa Mollusca


#Clean up by deleting split reads
rm -rf $PWD/${1%%.*}_mitoz/*fastq

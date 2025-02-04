#!/bin/bash
#SBATCH --job-name=bbduk                     
#SBATCH --mail-type=FAIL                         
#SBATCH --mail-user=byuen@mpi-bremen.de          
#SBATCH --ntasks=1                              
#SBATCH --cpus-per-task=10                     
#SBATCH --mem=1gb                             
#SBATCH --time=1:00:00                         
#SBATCH --output=bbduk_%j_slurm.out
#SBATCH --error=bbduk_%j_slurm.err
#SBATCH --partition=medium
#SBATCH -C scratch    

###usage###
#sbatch 01_filtering.sh readFile1.gz readFile2.gz

#will produce a single interleaved filtered file
WD="$(pwd)"

module load bbmap
rsync -v -L $1 $2 $TMP_SCRATCH

#unzip files
pigz -d -p 8 $TMP_SCRATCH/$1
pigz -d -p 8 $TMP_SCRATCH/$2

# filter fastq with bbduk - check for adapters and phiX contamination, trim sequences by q=15 and require at least 149 bases.
bbduk.sh -Xmx1g in1=$TMP_SCRATCH/${1%%.gz} in2=$TMP_SCRATCH/${2%%.gz} \
out1=$TMP_SCRATCH/${1}.adapterclean1.fastq out2=$TMP_SCRATCH/${2}.adapterclean2.fastq \
ref=/usr/product/bioinfo/BBMAP/38.68/resources/adapters.fa ktrim=r k=21 mink=11 hdist=2 tpe tbo

bbduk.sh -Xmx1g in1=$TMP_SCRATCH/${1}.adapterclean1.fastq in2=$TMP_SCRATCH/${2}.adapterclean2.fastq \
out1=$TMP_SCRATCH/${1}.reads.filtered_1.fastq out2=$TMP_SCRATCH/${2}.reads.filtered_2.fastq \
outm1=$TMP_SCRATCH/${1}.matched1.fq outm2=$TMP_SCRATCH/${2}.matched2.fq \
ref=/usr/product/bioinfo/BBMAP/38.68/resources/phix174_ill.ref.fa.gz ktrim=r k=21 mink=11 hdist=2 minlen=100 qtrim=r trimq=15

#clean up
rm -f $TMP_SCRATCH/${1}.adapterclean1.fastq 
rm -f $TMP_SCRATCH/${2}.adapterclean2.fastq 
rm -f $TMP_SCRATCH/*matched* 

#interleave reads and move to working directory

reformat.sh in1=$TMP_SCRATCH/${1}.reads.filtered_1.fastq in2=$TMP_SCRATCH/${2}.reads.filtered_2.fastq out=$TMP_SCRATCH/${1%%.*}.FILTERCOMBINED.fastq
pigz -p 8 $TMP_SCRATCH/${1%%.*}.FILTERCOMBINED.fastq
rsync $TMP_SCRATCH/${1%%.*}.FILTERCOMBINED.fastq.gz ${WD}/

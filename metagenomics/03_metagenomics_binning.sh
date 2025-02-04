#!/bin/bash
#
#SBATCH --job-name binner
#SBATCH --cpus-per-task=20
#SBATCH --mem=100GB
#SBATCH --output=binner-%j.out
#SBATCH --error=binner-%j.err
#SBATCH --partition=medium
#SBATCH --time=24:00:00 


###usage###
#sbatch .sh <samplename>
#run in assembly folder with reads in ../*fastq.gz

###dependencies###
#anaconda
#singularity
#BBMAP
#BWA
#samtools
#Metabat2
#Maxbin
#Binsanity
#DASTool

#save current working directory
WD="$PWD"
SAMPLE_ID=$1

module load singularity
module load anaconda3
source $ANACONDA3_ROOT/etc/profile.d/conda.sh 


##############################################  Processing contigs ############################################## 

conda activate /usr/users/benedict.yuen/conda_env/bbmap
#remove all contigs below 1000

reformat.sh in=scaffolds.fasta out=contigs-fixed.fa minlength=1000

conda deactivate


#simplify names
sed -i 's/NODE_/c/g' contigs-fixed.fa
sed -i 's/_length.*//g' contigs-fixed.fa

rsync -v -L contigs-fixed.fa ../*fastq.gz $TMP_SCRATCH


##############################################  Mapping ############################################## 

#map reads to scaffolds and convert to bams, then sort and index the bam file

module load bwa/0.7.12
module load samtools/1.12

bwa index $TMP_SCRATCH/contigs-fixed.fa

for f in $TMP_SCRATCH/*fastq.gz; do bwa mem  -t $SLURM_CPUS_PER_TASK $TMP_SCRATCH/contigs-fixed.fa $TMP_SCRATCH/${f##*/} | samtools sort -o $TMP_SCRATCH/${1}_${f##*/}_sorted.bam; done

for f in $TMP_SCRATCH/*fastq.gz; do samtools index $TMP_SCRATCH/${SAMPLE_ID}_${f##*/}_sorted.bam; done 

module unload bwa
module unload samtools

echo 'bams made, sorted, and indexed'




##############################################  Binning ############################################## 

###################### Metabat ######################

#run metabat wrapper script and metabat without coverage info

echo metabat with coverage

singularity exec -B $TMP_SCRATCH:/data,$WD /scratch/projects/eei/software/metabat2_2.15--h4da6f23_2.sif \
runMetaBat.sh --minContig 1500 -t $SLURM_CPUS_PER_TASK /data/contigs-fixed.fa /data/*sorted.bam 

mv contigs-fixed.fa.metabat-bin* METABAT

echo metabat without coverage

singularity exec -B $TMP_SCRATCH:/data,$WD /scratch/projects/eei/software/metabat2_2.15--h4da6f23_2.sif \
metabat2 --minContig 1500 -t $SLURM_CPUS_PER_TASK -i /data/contigs-fixed.fa -o $WD/METABAT_NOCOV/nocov

###################### Binsanity ######################

#run binsanity workflow

echo Binsanity profile to generate coverage data

singularity exec -B $TMP_SCRATCH:/data,$WD /scratch/projects/eei/software/binsanity_0.5.4--pyh5e36f6f_0.sif Binsanity-profile -i $WD/contigs-fixed.fa -s /data -c binsanity_${SAMPLE_ID}_coverage -T $SLURM_CPUS_PER_TASK 

echo Binsanity binning workflow

singularity exec -B $TMP_SCRATCH:/data,$WD /scratch/projects/eei/software/binsanity_0.5.4--pyh5e36f6f_0.sif Binsanity-wf -f /data -l contigs-fixed.fa -c binsanity_${SAMPLE_ID}_coverage.cov -o $WD/BINSANITY --threads $SLURM_CPUS_PER_TASK 


###################### Maxbin ######################

#run maxbin2
echo Run Maxbin

#summarise coverage stats
module load samtools/1.12
conda activate /usr/users/benedict.yuen/conda_env/bbmap
for f in $TMP_SCRATCH/*sorted.bam; do pileup.sh in=$f out=${f}_cov.txt; done
conda deactivate

rsync $TMP_SCRATCH/*_cov.txt $WD

#convert coverage to abundance - this is just reformatting coverage table for maxbin requirements

for f in *_cov.txt; do awk '{print $1"\t"$5}' $f | grep -v '^#' > ${f%%cov.txt}abundance.txt; done 

ls *abundance.txt > abundances.list

mkdir MAXBIN

singularity exec -B $WD /scratch/projects/eei/software/maxbin2_2.2.7--h87f3376_4.sif \
run_MaxBin.pl -contig $WD/contigs-fixed.fa \
-abund_list $WD/abundances.list \
-out $WD/MAXBIN/maxbin \
-thread $SLURM_CPUS_PER_TASK 

#clean up
#rm -rf $WD/*bam*

##############################################  das Tool ##############################################  
#compare and aggregate binning results

echo Run das Tool

mkdir dastool

singularity exec -B $WD /scratch/projects/eei/software/das_tool_1.1.6--r42hdfd78af_0.sif \
Fasta_to_Contig2Bin.sh -i BINSANITY/*Final*/ -e fna > binsanity.contigs2bin.tsv

singularity exec -B $WD /scratch/projects/eei/software/das_tool_1.1.6--r42hdfd78af_0.sif \
Fasta_to_Contig2Bin.sh -i MAXBIN/ -e fasta > maxbin.contigs2bin.tsv

singularity exec -B $WD /scratch/projects/eei/software/das_tool_1.1.6--r42hdfd78af_0.sif \
Fasta_to_Contig2Bin.sh -i METABAT/ -e fa > metabat.contigs2bin.tsv

singularity exec -B $WD /scratch/projects/eei/software/das_tool_1.1.6--r42hdfd78af_0.sif \
Fasta_to_Contig2Bin.sh -i METABAT_NOCOV/ -e fa > metabat_nocov.contigs2bin.tsv

singularity exec -B $WD /scratch/projects/eei/software/das_tool_1.1.6--r42hdfd78af_0.sif \
DAS_Tool  -i binsanity.contigs2bin.tsv,\
maxbin.contigs2bin.tsv,\
metabat.contigs2bin.tsv,\
metabat_nocov.contigs2bin.tsv \
-l binsanity,maxbin,metabat,metabat_nocov \
-c contigs-fixed.fa \
-o dastool/${SAMPLE_ID} \
-t $SLURM_CPUS_PER_TASK \
--write_bin_evals \
--write_bins

#rename bins
for i in $WD/dastool/${SAMPLE_ID}_DASTool_bins/*a; do mv "$i" $WD/dastool/${SAMPLE_ID}_DASTool_bins/${SAMPLE_ID}_"$(basename $i)"; done

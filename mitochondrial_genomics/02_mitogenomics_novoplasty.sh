#!/bin/bash
#
#SBATCH --job-name=mitos                 
#SBATCH --mail-type=FAIL   
#SBATCH --cpus-per-task=1
#SBATCH --mem=30gb
#SBATCH --time=03:00:00  
#SBATCH -C scratch
#SBATCH -p medium
#SBATCH  --output=slurm_%j_novoplasty.log

# Run in directory containing the reads, seed files can be any given directory
# Script customises the config file, runs novoplasty assembly with seed sequence provided, annotates assembly with mitos

### usage ###

#sbatch 01_mito_wf_1.sh CombinedReadFile.gz Seed.fasta
#input should be interleaved and filtered reads (produced by metagenomics filtering script)

READS=$1
SEED=$2
ID=${READS%%.FILTERCOMBINED.fastq.gz}

### make config file ###

# create file
touch ${ID}_config.txt

# Copy contents of config file template
< /usr/users/benedict.yuen/Software/NOVOPlasty/config.txt tee ./${ID}_config.txt

# Add project name to each config file
sed -i "s|^.*Project name          =.*$|Project name          = ${ID}|" ${ID}_config.txt

# Add reads file name to each config file
sed -i "s|^.*Combined reads        =.*$|Combined reads        = ${READS}|" ${ID}_config.txt

# Add seed file path to config file
sed -i "s|^.*Seed Input            =.*$|Seed Input            = ${SEED}|" ${ID}_config.txt


### run novoplasty ###
perl /usr/users/benedict.yuen/Software/NOVOPlasty/NOVOPlasty4.3.1.pl -c ${ID}_config.txt


# tidying up
rm -f contigs*${ID}*txt
rm -f log*${ID}*txt

# remove * from fasta (represents possible indel) - necessary for mitos input
sed -i 's/*//g' C*${ID}*fasta

### annotate with mitos ###

module purge
module load singularity


mkdir mitos_${ID}

singularity exec -B $PWD \

~/Software/mitos2.sif \

runmitos.py -c 5 --outdir mitos_${ID} -R $PWD -r /usr/users/benedict.yuen/Databases/refseq63m \

-i C*${ID}*fasta


# move mitogenome assembly fasta into mitos output folder
mv C*${ID}*fasta ./mitos_${ID}/
mv ${ID}_config.txt ./mitos_${ID}/

#!/bin/bash
#
#SBATCH --job-name gtdb
#SBATCH --cpus-per-task=8
#SBATCH --mem=128GB
#SBATCH --output=gtdb-%j.out
#SBATCH --error=gtdb-%j.err
#SBATCH --partition=medium
#sbatch .sh

#THIS NEEDS A LOT OF RAM

module load singularity

WD=$PWD

mkdir -p $TMP_SCRATCH/gtdbtk_io/genomes/

rsync -v -L *fa $TMP_SCRATCH/gtdbtk_io/genomes/
rsync -v -L /usr/users/benedict.yuen/GENOMES/WIEN_Jay/*fa $TMP_SCRATCH/gtdbtk_io/genomes/

singularity exec -B $TMP_SCRATCH/gtdbtk_io:/data,/scratch/projects/eei/software/gtdbtk-2.1.1/share/gtdbtk-2.1.1/db/release207_v2/:/refdata ~/Software/gtdbtk_latest.sif \
gtdbtk classify_wf -x fa --cpus $SLURM_CPUS_PER_TASK --genome_dir /data/genomes --out_dir /data/gtdb_output

mv $TMP_SCRATCH/gtdbtk_io/gtdb_output $WD

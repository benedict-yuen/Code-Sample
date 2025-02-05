# Lucinid Mitochondrial Genomes

## Overview 
This directory contains scripts used for bivalve mitochondrial genome assembly and annotation in the lucinid micochodrial genomes project.
The goal of this project was to maximise the output of gill metagenome data by extracting host reads for mitochondrial genome assembly. This supports the molecular classification of host taxonomy and the study of bivalve mitochondrial biology.
The code was written in BASH to assemble and annotate the lucinid michondrial genomes from Illumina metagenomic reads.


## Files and Functions
| File Name     | Description |
|--------------|------------|
| `01_filter_reads.sh`  | Preprocesses raw Illumina data, trims and filters out low-quality reads. |
| `02_mitogenomics_mitoz.sh` | Runs the MitoZ mitochondrial genome assembly and annotation workflow. |
| `02_mitogenomics_novoplasty.sh` | Alternate mitochondrial genome assembly (novoplasty) and annotation (mitos) worfklow. |

## Usage instructions

### Prerequisites
`01_filter_reads.sh`
- bbmap

`02_mitogenomics_mitoz.sh`
- bbmap
- singularity
- MitoZ_v3.4 singularity container (https://github.com/linzhi2013/MitoZ)

`02_mitogenomics_novoplasty.sh`
- singularity
- perl
- NOVOPlasty_v4.3.1 (https://github.com/ndierckx/NOVOPlasty)
- Mitos2 singularity container (https://gitlab.com/Bernt/MITOS)

### Running the Scripts

`sbatch 01_filter_reads.sh readFile1.gz readFile2.gz`

`sbatch 02_mitogenomics_mitoz.sh CombinedReadsFile.gz`

`sbatch 02_mitogenomics_novoplasty.sh CombinedReadsFile.gz Seed.fasta`

## Notes & Potential Improvements
These scripts were designed for lucinid gill metagenome Illumina reads and for use on the GWDG HPC, and will need modifications for other data and HPCs. The current mitogenomics workflow functions as intended, however, it was designed to be run on a small number of individual libraries.

Bivalve mitochondrial genomes can be large, complex and require iterative analysis to produce the optimum results. I would undertake these steps to scale the analysis:
- Use snakemake to automate the workflow, running MitoZ for different samples using different assemblers and kmer sizes
- Leverage parallelization to run these samples simultaneously
- Use a configuration file to define the assemblers and kmer combos
- Aggregate and summarise the assembly results to report the best assembly for each sample


## Author & Contact
Written by Benedict Yuen as part of the Eco-Evolutionary Interactions group at the Max Planck Institute for Marine Microbiology. Reach me at byuen@mpi-bremen.de.


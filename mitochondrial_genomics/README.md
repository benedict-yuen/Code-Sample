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

## Notes & Limitations
These scripts were designed for lucinid gill metagenome Illumina reads and for use on the GWDG HPC, and will need modifications for other data and HPCs

## Author & Contact
Written by Benedict Yuen as part of the Eco-Evolutionary Interactions group at the Max Planck Institute for Marine Microbiology. Reach me at byuen@mpi-bremen.de.


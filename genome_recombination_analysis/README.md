# Genome Recombination Analysis

## Overview
This directory contains scripts used for bivalve symbiont genome alignment and recombination analysis for a project investgating the genome evolution of a globally distributed symbiont Ca. Thiodiazotropha endolucinida (https://doi.org/10.1371/journal.pgen.1011295).
The goal of this project was to study the evolution of nitrogen fixation in a globally distributed bivalve symbiont. The code was written in BASH and should be use only on high quality MAGs (>90% completeness and <5% contamination).

## Files and Functions
| Filename                                    | Description |
|---------------------------------------------|------------|
| `01_recombination_alignment_coregenes.sh`   | Aligns genomes using Mauve and extracts core genes. |
| `02_recombination_realign_coregenes.sh`     | Refines core gene alignments for better accuracy. |
| `03_recombination_seed_tree_build.sh`       | Constructs a phylogenetic tree from aligned core genes. |
| `04_recombination_clonalframe.sh`           | Runs ClonalFrame to infer recombination events. |

## Usage Instruction

### Prerequisites

`01_recombination_alignment_coregenes.sh`
- anaconda
- mauve (conda environment)


`02_recombination_realign_coregenes.sh`
- The script for converting the xmfa file to fasta was obtained from: https://github.com/kjolley/seq_scripts/blob/master/xmfa2fasta.pl
- mafft
- perl

`03_recombination_seed_tree_build.sh`
- anaconda
- Trimal
- FastTree

`04_recombination_clonalframe.sh`
- ClonalFrameML
- R
- Visualising the ClonalFrame output: the R script cfml_results.R downloaded from the clonalframe github page https://github.com/xavierdidelot/ClonalFrameML/blob/master/src/cfml_results.R
- create a conda environment for the R packages. To run the Rscript for visualising the clonalframe output, make sure you have the R packages ape and phanghorn installed in the conda environment
(`conda install r-ape`; `conda install r-phanghorn`)

### Runing the scripts

`sbatch 01_recombination_alignment_coregenes.sh`

- Run script in working directory that contains a subdirectory ($PWD/genomes) with fasta files ending in.fa

`sbatch 02_recombination_realign_coregenes.sh`

- Run in directory containing output of `01_recombination_alignment_coregenes.sh`, input file should be named "core_mauve_aln.xmfa" 

`sbatch 03_recombination_seed_tree_build.sh`

- Run in directory containing output of `02_recombination_realign_coregenes.sh`, input file should be named "core_mauve_aln_cat_maffted.fa"

`sbatch 04_recombination_clonalframe.sh`

- Requires input tree from `03_recombination_seed_tree_build.sh`: "core_mauve_aln_cat_maffted_trim_FastTree.tre" 
- Requires input alignment from `03_recombination_seed_tree_build.sh`: "core_mauve_aln_cat_maffted_trim.fa"


## Notes

### Important Note on Calculating R/m and CI values 
r/m = 1/1/delta * R/theta * nu

Calculate confidence intervals (https://github.com/xavierdidelot/ClonalFrameML/issues/119): 
"When using the emsim option there is a much simpler (and better!) option to calculate the 95%CI of r/m. Each line of the file ending with suffix emsim.txtcontains sampled values of R/theta, delta and nu. Multiply these three values to get the sampled values of r/m for each line. The 95%CI is then obtained by taking the 2.5% and 97.5% quantiles of these sampled values. In R you can do this using: quantile(values,probs=c(0.025,0.975))
Yes if two 95%CI do not overlap then it suggests that there is a significant difference at the p=0.05 level.
When using embranch option things are a bit different since there will be parameter estimated for each branches."

### Potential Improvements
This project only targeted three species of bacteria so this workflow  was designed to be run on a single target species one at a time and lacks scalability.

Although the current version of this analysis pipeline does not yet incorporate full workflow automation, this is the approach I would implement moving forward to streamline the process and ensure smooth execution. The proposed workflow automation would involve sequential steps, where each step is executed only if the previous one has been successfully completed. This approach would help mitigate errors and improve the reproducibility of the analysis.

Intended workflow features:
- Step-wise execution: each step would be an independent module, where execution of a given step is dependent on successful completion of the prior step
- Completion checks/Output verification: I would add code checking that the necessary output is present and validated
- Error handling: I would include error handling for each module
 

## Author & Contact

Written by Benedict Yuen as part of the Eco-Evolutionary Interactions group at the Max Planck Institute for Marine Microbiology. Reach me at byuen@mpi-bremen.de.

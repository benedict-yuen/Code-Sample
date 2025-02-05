# Overview

I set up this repository containing examples of my code and experiences from previous bioinformatics projects to support my job search process. 

## Workflows  
Each workflow has its own README with detailed instructions. Click on the links below for more information:  

- **[Method 1: Symbiont Metagenomes](metagenomics/README.md)** – Symbiont MAG recovery workflow including assembly, binning, classification, QC, phylogenomic analysis  
- **[Method 2: Lucinid Mitochondrial Genomes](mitochondrial_genomics/README.md)** – Host mitochondrial genome recovery and functional annotation
- **[Method 3: Symbiont Genome Recombination](genome_recombination_analysis/README.md)** – Symbiont MAG alignment, core gene extraction, recombination analysis 
- **[Differential Expression (DE) Analysis](differential_expression/README.md)** - Scripts for DE analysis using **DESeq2**
- **[WGCNA Co-Expression Analysis](differential_expression/README.md)** - Unsupervised network analysis to identify correlated gene modules, extract functional insights, and explore complex expression patterns in omics datasets.

## Notes on Code Quality and Future Improvements
While the code provided here is functional and addresses the specific needs of the analysis, I acknowledge that it may not be fully optimized for general use or scalability. This reflects my focus on solving the immediate problem at hand with available resources.

I am keen on learning and improving my coding practices. Going forward, I would:
- Improve modularity and replicability through better workflow management using snakemake, particularly for the metagenomic and metatranscriptomic analysis
- Enhance error handling to make the code more robust
- Optimise performance for larger datasets by incorporating more efficient parallelization and the use of array scripts
- Incorporating version control practices using git


## Contact
For any questions or issues, please reach out to Benedict Yuen at benedict.yuen@uqconnect.edu.au or byuen@mpi-bremen.de.
Feedback and suggestions are always welcome, and I am committed to continuous improvement in my work!

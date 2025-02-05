# Differential Expression and Co-Expression Analysis 

## Overview

This directory contains R scripts for analysing gene expression patterns using differential expression (DE) analysis and Weighted Gene Co-Expression Analysis (WGCNA). These scripts were developed to investigate the transcriptomic responses of a chemosymbiotic bivalve to prolonged sulhide-deprivation. 
The experiment comprised three conditions: wild caught (Fresh) clams, clams in aquaria for 10 weeks without a sulphide supply (Washed), clams in aquaria for 10 weeks with a sulphide supply (Sulphidic). 

## Files Included

| File Name     | Description |
|--------------|------------|
| `deseq2_BY04_analysis.Rmd` | R Markdown script for DE  |
| `deseq2_BY04_analysis.html` | Rendered HTML output showing DESeq2results and visualizations. |
| `WGCNA_1_BY04_host-var50-filter-data.R` | R script filtering DESeq2 filtering counts for WGCNA input|
| `WGCNA_2_BY04_host-var20_dataInput_13082024.Rmd` | R Markdown script for preprocessing and formatting WGCNA input data |
| `WGCNA_2_BY04_host-var20_dataInput_13082024.html` | Rendered HTML showing WGCNA data input step and initial checks |
| `WGCNA_3_BY04_host-var20_SignedNetworkConstr-blockwise_13082024.Rmd` | R Markdown script for constructing a signed co-expression network using blockwise modules. |
| `WGCNA_3_BY04_host-var20_SignedNetworkConstr-blockwise_13082024.html` | Rendered HTML output showing network construction, clustering, and module detection results. |
| `WGCNA_4_BY04_host-var20_relateSignedModsToExt_13082024.Rmd` | R Markdown script for relating co-expression modules to external traits (e.g., sample metadata, phenotypic data). |
| `WGCNA_4_BY04_host-var20_relateSignedModsToExt_13082024.html` | Rendered HTML output showing module-trait relationships and statistical associations. |


## Methods
1. Differential Expression Analysis
- Uses DESeq2 to identify differentially expressed genes.
- Generates transformed counts data for downstream analyses
- Generates PCA plot and heatmaps for results visualisation and exploration

2. Co-Expression Analysis (WGCNA)
- Constructs gene co-expression networks.
- Identifies modules of co-regulated genes.


## Usage Instructions

To run the analysis, open R and execute:

`rmarkdown::render("deseq2_BY04_analysis.Rmd")` 

### Required Input Data
- Salmon read mapping output
- Transcript to gene mapping table (generated using CORSET if working with reference transcriptome)
- Sample metadata table
- Gene functional annotation table (generated using eggnogmapper or blast2go)

### Dependencies

#### DESeq2
- tximport
- readr
- DESeq2
- ggplot2
- gplots
- RColorBrewer
- pheatmap
- IHW
- ashr
- tidyverse

#### WGCNA
- genefilter
- WGCNA

## Notes and Limitations
These scripts identify the important genes that were differentially expressed in response to the experimental conditions. Further (GO term/KEGG) enrichment analyses and visualisation steps (e.g. heatmaps, bubble plots)  are necessary to summarise the data for reporting.

## Contact
For any questions, reach out to benedict.yuen@uqconnect.edu.au.

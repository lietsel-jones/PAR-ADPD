# Multi-ancestry Population Attributable Risk Assessment of Common Genetic Variation in Alzheimer’s and Parkinson’s Diseases

`GP2 ❤️ Open Science 😍`

[![DOI](https://zenodo.org/badge/858781253.svg)](https://zenodo.org/doi/10.5281/zenodo.13774455)

**Last Updated:** February 2025

## Summary
This is the online repository for the manuscript titled ***"Multi-ancestry Population Attributable Risk Assessment of Common Genetic Variation in Alzheimer’s and Parkinson’s Diseases"***.

This study aims to assess the population attributable risk (PAR) for Alzheimer’s disease (AD) and Parkinson's disease (PD) across diverse ancestries, thereby identifying genetic disparities in risk factors and their implications for precision medicine. Using genome-wide association data from multiple ethnicities, our analysis revealed that genetic susceptibilities vary significantly across populations, with several loci showing unique associations in non-European ancestries. These findings highlight the critical need for developing therapeutic strategies that are personalized to genetic backgrounds, ensuring effective and equitable treatment across all population groups.

### Data Statement 
Our reference datasets consisted of summary statistics from previously published studies. 23andMe GWAS summary statistics (available via collaboration with 23andMe).
* Parkinson's disease
    * European GWAS meta-analysis; Nalls et al 2019; [see here](https://ndkp.hugeamp.org/phenotype.html?ancestry=EU&phenotype=PDAndFirstDegree)
    * African and African admixed GWAS meta-analysis; Rizig et al 2023; [see here](https://ndkp.hugeamp.org/dinspector.html?dataset=Rizig2023_Parkinsons_AF)
    * East Asian GWAS meta-analysis; Foo et al 2020; [see here](https://www.ebi.ac.uk/gwas/publications/32310270)
    * Latino GWAS meta-analysis; Loesch et al 2021; [see here](https://ndkp.hugeamp.org/dinspector.html?dataset=Loesch2021_Parkinsons_HS)

• Alzheimer's disease
   * AD GWAS meta-analysis; Bellenguez et al 2022; https://www.ebi.ac.uk/gwas/ (accession no. GCST90027158)
   * European AD GWAS meta-analysis; [see here](https://dss.niagads.org/datasets/ng00075/)
   * African American GWAS meta-analysis; Kunkle 2021; [see here](https://www.ebi.ac.uk/gwas/publications/33074286)
   * East Asian GWAS meta-analysis; Shigemizu et al 2021; [see here](https://www.ebi.ac.uk/gwas/publications/33654092)
   * Latino GWAS meta-analysis; Lake et al 2023; [see here](https://ndkp.hugeamp.org/dinspector.html?dataset=Lake2023_AD_Mixed)

### Helpful Links 
- *coming soon* pre-print 
- [GP2 Website](https://gp2.org/)
    - [GP2 Cohort Dashboard](https://gp2.org/cohort-dashboard-advanced/)
- [Introduction to GP2](https://movementdisorders.onlinelibrary.wiley.com/doi/10.1002/mds.28494)
    - [Other GP2 Manuscripts (PubMed)](https://pubmed.ncbi.nlm.nih.gov/?term=%22global+parkinson%27s+genetics+program%22)


# Repository Orientation 
- The `analyses/` directory includes all analyses discussed in the manuscript

```
.
├── LICENSE
├── README.md
├── analyses
│   ├── 00_clean_and_prep_PD.ipynb
│   ├── 01_PAR_calculations_PD.ipynb
│   ├── 02_clean_and_prep_AD_revised.ipynb
│   ├── 03_PAR_calculations_AD.ipynb
│   ├── 04_PD_EUR_fine_mapping.ipynb
│   ├── 05_PD_AFR_fine_mapping.ipynb
│   ├── 06_PD_EAS_fine_mapping.ipynb
│   ├── 07_PD_LAT_fine_mapping.ipynb
│   ├── 08_AD_EUR_fine_mapping.ipynb
│   ├── 09_AD_AFR_fine_mapping.ipynb
│   ├── 10_AD_EAS_fine_mapping.ipynb
│   ├── 11_AD_LAT_fine_mapping.ipynb
│   ├── 12_PAR_finemapped_variants.ipynb
│   ├── 13_data_visualization_known_variants.R
│   └── 14_data_visualization_all.R
└── tables
    └── PAR_Supplementary_Tables.xlsx
```

---
### Analysis Notebooks
* Languages: Python, bash, and R

| **Notebooks**                | **Description**                                                                                                                                  |
|:-----------------------------:|:------------------------------------------------------------------------------------------------------------------------------------------------:|
| 00_clean_and_prep_PD.ipynb    | Load list of 90 PD risk loci from Nalls publication, import ancestry-specific GWAS summary statistics, select top hits, and identify known/population-specific variants for analysis. |
| 01_PAR_calculations_PD.ipynb  | Calculate population attributable risk (PAR) for each target and generate a table with summary statistics and PAR.                              |
| 02_clean_and_prep_AD_revised.ipynb    | Import AD datasets for each ancestry, clean and filter p-values < 0.05, select top hits for each ancestry, and generate dataset for calculations. |
| 03_PAR_calculations_AD.ipynb  | Calculate population attributable risk (PAR) for each target and generate a table with summary statistics and PAR.                              |
| 04_PD_EUR_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in EUR population, perform fine-mapping, and save results. |
| 05_PD_AFR_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in AFR population, perform fine-mapping, and save results. |
| 06_PD_EAS_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in EAS population, perform fine-mapping, and save results. |
| 07_PD_LAT_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in LAT population, perform fine-mapping, and save results. |
| 08_AD_EUR_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in EUR population, perform fine-mapping, and save results. |
| 09_AD_AFR_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in AFR population, perform fine-mapping, and save results. |
| 10_AD_EAS_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in EAS population, perform fine-mapping, and save results. |
| 11_AD_LAT_fine_mapping.ipynb  | Extract chromosome and base pair positions from summary statistics for selected loci in LAT population, perform fine-mapping, and save results. |
| 12_PAR_finemapped_variants.ipynb | Combine results from fine-mapping analysis, add necessary summary statistics, calculate PAR for variants with high posterior probability, and save results. |
| 13_data_visualization_known_variants.R | Visualize known disease variants within genes of interest across different ancestries. |
| 14_data_visualization_all.R   | Visualize population attributable risk (PAR) for each ancestry using R scripts. |

---

# Software 

| Software | Version(s) | Resource URL | RRID | Notes |
| -------- | ---------- | ------------ | ---- | ----- |
| Python Programming Language         | 3.9         | [http://www.python.org/](http://www.python.org/)        | RRID:SCR_008394 | pandas; numpy; seaborn; matplotlib; statsmodel; used for general data wrangling/plotting/analyses |
| R Project for Statistical Computing | 4.2                 | [http://www.r-project.org/](http://www.r-project.org/)  | RRID:SCR_001905 | tidyverse; dplyr; tidyr; ggplot; data.table; used for general data wrangling/plotting/analyses                   |
| ANNOVAR         | 2020-06-08        | [http://www.openbioinformatics.org/annovar/](http://www.openbioinformatics.org/annovar/)        | RRID:SCR_012821| Genetic annotation software |


# Multi-ancestry Population Attributable Risk Assessment of Common Genetic Variation in Alzheimer’s and Parkinson’s Diseases

`GP2 ❤️ Open Science 😍`

#### Add DOI here

**Last Updated:** September 2024

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
  - AD GWAS meta-analysis; Bellenguez et al 2022; https://www.ebi.ac.uk/gwas/ (accession no. GCST90027158)
  * FinnGen Release 6; [see here](https://r6.finngen.fi/pheno/G6_AD_WIDE_EXMORE)
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
analyses/
├── 00_clean_and_prep_PD.ipynb
├── 01_PAR_calculations_PD.ipynb
├── 02_clean_and_prep_AD.ipynb
├── 03_PAR_calculations_AD.ipynb
├── 04_data_visualization_all.R
└── 05_data_visualization_known_variants.R
```

---
### Analysis Notebooks
* Languages: Python, bash, and R

| **Notebooks** | **Description** |
|:-------------:|:---------------:|
| 00_clean_and_prep_PD.ipynb	| Load the list of  PD risk loci, import ancestry-specific GWAS summary statistics, select top hits for each ancestry, and identify known and population-specific risk variants for analysis. |
| 01_PAR_calculations_PD.ipynb	| Calculate population attributable risk for each target and generate table with summary statistics and PAR |
| 02_clean_and_prep_AD.ipynb	| Load the list of  AD risk loci, import ancestry-specific GWAS summary statistics, select top hits for each ancestry, and identify known and population-specific risk variants for analysis. |
| 03_PAR_calculations_AD.ipynb	| Calculate population attributable risk for each target and generate table with summary statistics and PAR |
| 04_data_visualization_all.R	| Rscript to visualize PAR in each ancestry |
| 05_data_visualization_known_variants.R | Rscript to visualize known disease variants within genes of interest |


---

# Software 

| Software | Version(s) | Resource URL | RRID | Notes |
| -------- | ---------- | ------------ | ---- | ----- |
| Python Programming Language         | 3.9         | [http://www.python.org/](http://www.python.org/)        | RRID:SCR_008394 | pandas; numpy; seaborn; matplotlib; statsmodel; used for general data wrangling/plotting/analyses |
| R Project for Statistical Computing | 4.2                 | [http://www.r-project.org/](http://www.r-project.org/)  | RRID:SCR_001905 | tidyverse; dplyr; tidyr; ggplot; data.table; used for general data wrangling/plotting/analyses                   |
| ANNOVAR         | 2020-06-08        | [http://www.openbioinformatics.org/annovar/](http://www.openbioinformatics.org/annovar/)        | RRID:SCR_012821| Genetic annotation software |
# Cam's Genetics project

The Genetics of Autoimmune and Connective Tissue Disorders
## Abstract
EDS is a heritable connective tissue disorder that affects the elements of the skin, joints, and blood vessels. It is associated with many potential deleterious genetic variants. EDS is characterized by joint hypermobility, tissue fragility, and can lead to a range of complications, including joint dislocations, chronic pain, and cardiovascular problems. 

## Project Overview

This project is a personal genomic analysis project with the goal of linking several medical phenotypes to a genotype. The project is divided into several parts, each focusing on a different aspect of the analysis. The main goal is to identify genetic variants associated with specific medical conditions and to understand the underlying related biological mechanisms.   

The project will utilize various data sources, including genetic databases and medical literature, to gather information on genetic variants and their associations with diseases. The analysis will involve statistical methods to compare the frequency of disease-associated alleles in patients with specific medical conditions against the general population. The findings will be visualized using various plotting techniques to illustrate the results.

The project will also include a discussion of the implications of the findings for diagnosis and treatment of the medical conditions studied. The ultimate goal is to contribute to the understanding of the genetic basis of these conditions and to provide insights that may inform future research and clinical practice.

## Medical Phenotype Scope
The following medical conditions are of interest in this project. Each condition is associated with specific genetic variants that may contribute to its pathophysiology. The table below summarizes the conditions, their acronyms, and key symptoms.

Acronym | Condition | Symptoms
--- | --- | ---
EDS | Ehlers-Danlos Syndrome | Joint hypermobility, skin hyperextensibility, and tissue fragility
MCAS | Mast Cell Activation Syndrome | Increased immune activation leading to allergic symptoms
ASD | Autism Spectrum Disorder | Neurodevelopmental disorder affecting communication and behavior
POTS | Postural Orthostatic Tachycardia Syndrome | Abnormal increase in heart rate (>30 BPM increase for >1 min) upon postural change or otherwise insignificant stimulus
CD | Celiac Disease | Autoimmune disorder triggered by gluten ingestion, leading to intestinal damage and malabsorption
RA | Rheumatoid Arthritis | Autoimmune disorder causing joint inflammation and pain
CFS | Chronic Fatigue Syndrome | Persistent fatigue not improved by rest, often accompanied by other symptoms
CD | Crohn's Disease | Inflammatory bowel disease causing chronic inflammation of the gastrointestinal tract
CP | Chronic Pain | Persistent pain lasting longer than 3 months, often without a clear cause
AoD | Aortic Dissection | Tear in the aorta wall leading to severe pain and potential life-threatening complications
UI | Uterine Incompetence | Premature birth or miscarriage due to weak cervix
PFD | Pelvic floor dysfunction | Weakness or dysfunction of pelvic floor muscles, leading to urinary incontinence, pelvic pain, and other symptoms

## Hypotheses
Null hypothesis: There is no significant difference between the average number of disease-associated alleles found in patients diagnosed with at least 1 of select health-affecting genotypes compared to the general population.

Alternative hypothesis: There is a significant difference between the average number of disease-associated alleles found in patients diagnosed with at least 1 of select health-affecting genotypes compared to the general population.

## Methodology
1. **Data Collection**: Collect genetic data from various sources, including NCBI, ClinVar, OMIM, GeneCards, ExAC, GnomAD, 1000 Genomes, dbSNP, Ensembl, and UCSC Genome Browser.
2. **Data Processing**: Clean and preprocess the data to ensure consistency and accuracy.
3. **Variant Annotation**: Annotate genetic variants with relevant information, including gene names, disease associations, and population frequencies.
4. **Statistical Analysis**: Perform statistical tests to compare the average number of disease-associated alleles in patients with specific medical conditions against the general population.
5. **Visualization**: Create visualizations to illustrate the findings, including histograms, box plots, and scatter plots.
6. **Interpretation**: Interpret the results in the context of the medical conditions and genetic variants, discussing potential implications for diagnosis and treatment.

## Research / Note-taking

Theory 1:
- Connective tissues are derived from mesodermal cells, which are the middle layer of embryonic tissue. These cells differentiate into various cell types, including fibroblasts, chondrocytes, and osteoblasts, which are responsible for producing the extracellular matrix components that make up connective tissues.
- The extracellular matrix is composed of proteins, glycoproteins, and proteoglycans that provide structural support to tissues and organs. It also plays a crucial role in cell signaling and communication.
- Mesoderm cells invaginate to initiate embryonic gastrulation, and are responisble for producing the signalling factors that induce ectodermal cells to differentiate into skin and nervous tissue.  
___(Purves et al., 2018)___  
  
**My Theory**: If the mesoderm has a genetic variant impacting its signalling to ectoderm precursors, the skin and nervous tissue are derived from ectodermal cells might be impacted. This could be a potential mechanism for the association between the connective tissue disorders and neurodevelopmental disorders under investigation.

If this was the mechanism of the association, we would expect to see a higher frequency of disease-associated alleles in patients with at least one diagnosed connective tissue, autoimmune or neurodevelopmental disorder compared to the general population. These alleles would be expected to be associated with genes involved in the development and function of connective tissues, as well as genes involved in neurodevelopment and immune regulation.

Theory 2:
- The HLA (human leukocyte antigen) system is a group of genes located in the MHC complex in chromosome 6, that play a crucial role in the immune system. 
- HLA genes encode proteins that are involved in the recognition and presentation of antigens to T cells, which are essential for the adaptive immune response. Variations in HLA genes have been associated with various autoimmune diseases, including Rheumatoid Arthritis, Celiac Disease, and Mast Cell Activation Syndrome. 
- Although the MHC locus is relatively large, it was the first region of the human genome to be described in terms of haplotype structure. The MHC haplotype is a set of alleles that are inherited together on a single chromosome and can influence the risk of developing autoimmune diseases.
**My theory**: If there is a genetic mechanism underpinning this maintenance of haplotype structure, variants could promote the incorporation of neighbouring genes into the haplotype, which could lead to the association of these genes with autoimmune diseases. This could be due to the presence of regulatory elements or enhancers that influence the expression of nearby genes, leading to a higher frequency of disease-associated alleles in patients with autoimmune diseases.

## Data Sources
- NCBI: https://www.ncbi.nlm.nih.gov/
- ClinVar: https://www.ncbi.nlm.nih.gov/clinvar/
- OMIM: https://omim.org/
- GeneCards: https://www.genecards.org/
- ExAC: http://exac.broadinstitute.org/
- GnomAD: https://gnomad.broadinstitute.org/
- dbSNP: https://www.ncbi.nlm.nih.gov/snp/
- Ensembl: https://www.ensembl.org/
- UCSC Genome Browser: https://genome.ucsc.edu/


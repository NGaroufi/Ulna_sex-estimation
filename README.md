# Ulna_sex-estimation
Dataset and code used for the research paper titled "Sex through the lens of cross-sectional geometric properties of ulnae bones"

All analyses presented in the research paper titled "Sex through the lens of cross-sectional geometric properties of ulnae bones" can be replicated using the datasets and code scripts provided in this repository. 

## Datasets
The dataset `Complete Data - Ulna.csv` contains the information extracted from the [*csg-toolkit*](https://github.com/pr0m1th3as/long-bone-diaphyseal-CSG-Toolkit/tree/v1.0.1) GNU Octave package, while the `GR.csv` dataset contains the information regarding sex and age-at-death of the Athens Collection.

## Code scripts
1. The `compile_data.m` GNU Octave script is responsible for computing the finalized version of the working dataset. More specifically, it keeps the variables needed for the analysis, calculates the extra ratios, and checks the dataset for outliers, removing them case-wise.

2. The `statistical_analysis.m` GNU Octave script was used for the conduction of the bilateral asymmetry analysis.

3. The `histograms.m` GNU Octave script produces the age-at-death distribution plots, while also creating a CSV file for the pooled sample.

4. The `age_gam.R` R script is responsible for the examination of the correlation between age-at-death and the utilized variables (analysis and plots).

5. The `rbf_svm.R` R script was utilized for the creation of RBF SVM classification models. It contains all the examined scenarios in regards to the hyper-parameter values (cost, gamma), as well as the creation of plots and the examination of the accuracy on the training sample. The last step was not included in the research paper, as it was mostly utilized as a way to monitor over-fitting during the analysis. 

6. The `boxplot.m` and `plot_arrangements.R` scripts function as supporting scripts for the above analyses and the arrangment of the age-at-death GAM plots in the Supplementary Material section of the research paper respectively.

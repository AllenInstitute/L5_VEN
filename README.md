# VENcelltypes
This repository contains code for reproducing the analysis of snRNA-seq data from human fronto-insula

While this is set up as an R library for convenience, it is really just a wrapper for the analysis functions and does not follow all of the conventions of R libraries (function annotation, unit testing, etc.).  Please be sure to cite the appropriate other R libraries if replicating the code.  

Install using:
```
# Quickly, but without the vignettes:
devtools::install_github("AllenInstitute/VENcelltypes")

# More slowly, but with the vignettes:
devtools::install_github("AllenInstitute/VENcelltypes", build_opts = c("--no-resave-data", "--no-manual"))
```
## Code book

To replicate the figures in the paper, please use the code below or (load them from within R):

1. **Code 1. Download and prepare the data** [(LINK TO SCRIPT)](http://htmlpreview.github.io/?https://github.com/AllenInstitute/VENcelltypes/blob/master/vignettes/Code1_prepareComparisonDataSets.nb.html)  This script reads converts data downloaded from the [Allen Institute Cell Types Database](http://celltypes.brain-map.org/rnaseq) into a format compatible for use as comparison data to human fronto-insula.  
2. **Code 2. Rename clusters and build tree** [(LINK TO SCRIPT)](http://htmlpreview.github.io/?https://github.com/AllenInstitute/VENcelltypes/blob/master/vignettes/Code2_clusterNames_buildTree_Fig1.nb.html)  This script reads in the data and assigned clusters, organizes the clusters into a dendrogram, renames the clusters to include class information and informative genes, and then plots some summary plots.  
3. **Code 3. Quality control assessment** [(LINK TO SCRIPT)](http://htmlpreview.github.io/?https://github.com/AllenInstitute/VENcelltypes/blob/master/vignettes/Code3_QC_assessment_FigS1.nb.html)  This script reads in the data output to the feather files and uses it to calculate and plot some QC information for Supplementary figure 1.  
4. **Code 4. Cross-species analysis** [(LINK TO SCRIPT)](http://htmlpreview.github.io/?https://github.com/AllenInstitute/VENcelltypes/blob/master/vignettes/Code4_crossSpeciesComparisons.nb.html)  This script performs alignment of deep excitatory neurons in human fronto-insula, human middle temporal gyrus, mouse primary visual cortex, and mouse anterior lateral motor cortex.  It also identifies genes with common and distinct patterning across these data sets.  
5. **Code 5. Human FI vs. Human MTG comparison** [(LINK TO SCRIPT)](http://htmlpreview.github.io/?https://github.com/AllenInstitute/VENcelltypes/blob/master/vignettes/Code5_humanMTGvsFI.nb.html)  This script identifies common and distinct CF-associated genes in human middle temporal gyrus as compared with human fronto-insula, and compares the proportions of cells across clusters for each brain region.  

Please e-mail jeremym@alleninstitute.org with any issues.

## License

The license for this package is available on Github at: https://github.com/AllenInstitute/mfishtools/blob/master/LICENSE

## Level of Support

This code will be updated only if figures change during review.

## Contribution Agreement

If you contribute code to this repository through pull requests or other mechanisms, you are subject to the Allen Institute Contribution Agreement, which is available in full at: https://github.com/AllenInstitute/mfishtools/blob/master/CONTRIBUTION

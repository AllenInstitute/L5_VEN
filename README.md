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

1. **Code 1.** [(LINK TO SCRIPT)](http://htmlpreview.github.io/?https://github.com/AllenInstitute/VENcelltypes/blob/master/vignettes/SCRIPT_NAME.html)  Description here.  
2. **Code 1.** [(LINK TO SCRIPT)](http://htmlpreview.github.io/?https://github.com/AllenInstitute/VENcelltypes/blob/master/vignettes/SCRIPT_NAME.html)  Description here.    

Please e-mail jeremym@alleninstitute.org with any issues.

## License

The license for this package is available on Github at: https://github.com/AllenInstitute/mfishtools/blob/master/LICENSE

## Level of Support

This code will be updated only if figures change during review.

## Contribution Agreement

If you contribute code to this repository through pull requests or other mechanisms, you are subject to the Allen Institute Contribution Agreement, which is available in full at: https://github.com/AllenInstitute/mfishtools/blob/master/CONTRIBUTION

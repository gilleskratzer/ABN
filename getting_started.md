# Getting started checklist

In order to best profit from the [abn](https://cran.r-project.org/package=abn) features additonal libraries are recommended.

- Install [abn](https://cran.r-project.org/package=abn) from CRAN:
```r
install.packages("abn")
```
- [INLA](http://www.r-inla.org/) which is an R package but hosted separately from CRAN and is easy to install for common platforms (see instructions on INLA website). This package can be used for model fitting:
```r
install.packages("INLA", repos=c(getOption("repos"), INLA="https://inla.r-inla-download.org/R/stable"), dep=TRUE)
```
- [Rgraphviz](http://www.bioconductor.org/packages/release/bioc/html/Rgraphviz.html)hosted on  Bioconductor. This package is used to produce plots of network graphs.
```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("Rgraphviz", version = "3.8")
```
- Install [JAGS](http://mcmc-jags.sourceforge.net/) (Operating System dependant). 

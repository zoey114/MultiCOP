# MultiCOP: An Integrative Analysis of Microbiome-Metabolome Associations

**This repository contains code for the paper "MultiCOP: An Integrative Analysis of Microbiome-Metabolome Associations"**


### Introduction

We introduce the **MultiCOP** algorithm, a method designed for the efficient integration of microbiome and metabolome data. Its primary objective is to reveal microbe-metabolite interactions and pinpoint pertinent microbes and metabolites by leveraging correlation pursuit combined with random projection. Additionally, the **MultiCOP** algorithm is versatile, and capable of investigating associations between any two high-dimensional datasets to identify relevant features. 

The Taxon Set Enrichment Analysis ([TSEA](https://edisciplinas.usp.br/pluginfile.php/5269697/mod_resource/content/2/2020-Using%20MicrobiomeAnalyst%20for%20comprehensive%20statistical,%20functional,%20and%20meta-analysis%20of%20microbiome%20data.pdf)) is then applied to directly investigate whether the selected microbes showcase enrichments within taxon sets functionally related to the microbiome-metabolite interaction.


### Tutorial

MultiCOP requires two data tables in matrix form as input, denoted as **X** and **Y**, each with dimensions of n_sample by n_feature. The instructions for implementing MultiCOP are available in [code/example/example.Rmd](https://github.com/zoey114/MultiCOP/blob/main/example/example.Rmd). The tutorial shows how to implement the first scenario in simulation.


### R package

#### Installment:
We have also developed an R package for ease of use. You can download the R package [here](https://github.com/zoey114/MultiCOP/tree/main/code/R). Once downloaded, follow the steps below to install it:

```{r}
install.packages("MultiCOP")
```


#### Usage:

You can implement the first scenario in simulation using:

```{r}
library("MultiCOP")
sub = multicop(X, Y, alpha.in.list, alpha.out.list, m, my.range)
X_sub = sub[[1]]
Y_sub = sub[[2]]
```

The output would be the selected subset of **$X$** and **$Y$**, denoted as $X_{sub}$ and $Y_{sub}$.

```{r}
cat("The selected subset in X: ", X_sub, '\n')
cat("The selected subset in Y: ", Y_sub, '\n')
```
And the outputs: 

The selected subset in X:  1 2 3 

The selected subset in Y:  3 2 1 

### Data used in the paper

The original dataset of Inflammatory bowel disease (IBD) is available [here](https://ibdmdb.org/tunnel/public/summary.html).

The original dataset of Chronic Ischemic Heart Disease (CIHD) is available [here](https://www.nature.com/articles/s41591-022-01688-4).


### Reference
  - Zhong, Wenxuan, et al. "Correlation pursuit: forward stepwise variable selection for index models." Journal of the Royal Statistical Society Series B: Statistical Methodology 74.5 (2012): 849-870.
  - Chong, J., Liu, P., Zhou, G., Xia, J.: Using microbiome analyst for comprehensive statistical, functional, and meta-analysis of microbiome data. Nature protocols 15(3), 799–821 (2020).


### License

Copyright © 2023 [Zoey](https://github.com/zoey114). <br />
This project is [MIT](https://github.com/zoey114/MultiCOP/blob/main/LICENSE) licensed.


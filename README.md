# MultiCOP: An Integrative Analysis of Microbiome-Metabolome Associations

**This repository contains code for the paper "MultiCOP: An Integrative Analysis of Microbiome-Metabolome Associations"**


### Introduction

We introduce the **MultiCOP** algorithm, a method designed for the efficient integration of microbiome and metabolome data. Its primary objective is to reveal microbe-metabolite interactions and pinpoint pertinent microbes and metabolites by leveraging correlation pursuit combined with random projection. Additionally, the **MultiCOP** algorithm is versatile, capable of investigating associations between any two high-dimensional datasets to identify relevant features. 

The Taxon Set Enrichment Analysis ([TSEA](xxxxxx)) is then applied to directly investigate whether the selected microbes showcase enrichments within taxon sets functionally related to the microbiome-metabolite interaction.


### Tutorial

MultiCOP requires two data tables in matrix form as input, denoted as **X** and **Y**, each with dimensions of n_sample by n_feature. The instructions for implementing MultiCOP are available in [code/example/example.Rmd](https://github.com/zoey114/MultiCOP/blob/main/code/example/example.Rmd). The tutorial shows how to implement the first scenario in simulation.


### R package

#### Installment:
We have also developed an R package for ease of use. You can download the R package [here](xxxxxxxxxxx). Once downloaded, follow the steps below to install it:

```{r}
install.packages("MultiCOP")
```

#### Dependencies:

Dependencies can be found in [xxxx](xxxxxx).


#### Usage:

You can implement the first scenario in simulation using:

```{r}
install.packages("MultiCOP")
xxxxxxxx
xxxxxxxx
```




### Data used in the paper

The original dataset of Inflammatory bowel disease (IBD) is available [here]().

The original dataset of Chronic Ischemic Heart Disease (CIHD) is available [here]().


### Reference:
  - Zhong, Wenxuan, et al. "Correlation pursuit: forward stepwise variable selection for index models." Journal of the Royal Statistical Society Series B: Statistical Methodology 74.5 (2012): 849-870.
  - Chong, J., Liu, P., Zhou, G., Xia, J.: Using microbiomeanalyst for comprehensive statistical, functional, and meta-analysis of microbiome data. Nature protocols 15(3), 799–821 (2020).


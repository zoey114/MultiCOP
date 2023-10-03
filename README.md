# MultiCOP - Variable selection for Multiresponse index model via correlation pursuit 

**This repository contains code for the paper "MultiCOP: An Integrative Analysis of Microbiome-Metabolome Associations"**


### Introduction

We propose the multivariate correlation pursuit (\textsc{MultiCOP}) algorithm, which effectively integrates microbiome and metabolome data to uncover microbe-metabolite interactions and find relevant microbes/metabolites by applying correlation pursuit and random projection. The \textsc{MultiCOP} algorithm can also be applied to explore the association between any two high dimensional dataset and find the relevant features. 


### Tutorial

Multicop requires two data tables in matrix form as input, denoted as **X** and **Y**, each with dimensions of n_sample by n_feature. The instructions for implementing MultiCOP are available in [code/example/example.Rmd](https://github.com/zoey114/MultiCOP/blob/main/code/example/example.Rmd). The tutorial shows how to implement the first scenario in simulation.


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



### Reference:
  - Zhong, Wenxuan, et al. "Correlation pursuit: forward stepwise variable selection for index models." Journal of the Royal Statistical Society Series B: Statistical Methodology 74.5 (2012): 849-870.


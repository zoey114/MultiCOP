# MultiCOP - Variable selection for Multiresponse index model via correlation pursuit 

**This repository contains code for paper "MultiCOP: An Integrative Analysis of Microbiome-Metabolome Associations"**


### Installation:
You can install the R package by:

```{r}
install.packages("MultiCOP")
```
### An example
1. Input data:
Multicop requires two data tables in matrix form as input, denoted as X and Y, each with dimensions of n_sample by n_feature.

Put [code/example/example.Rmd](https://github.com/zoey114/MultiCOP/blob/main/code/example/example.Rmd)

3. Example:
```{r}
# read data in the example folder. 
X = read.csv("input_X.txt")
Y = read.csv("input_Y.txt")
# set parameters
alpha.in = 0.95;alpha.out = 0.90;my.range=100;m=1000
# run the algorithm. 
scalar.Y = scalar.y(Y, m=m)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
result.X <- foreach(i = 1:ncol(scalar.Y)) %dopar% {
  step.multicop.x(i)
}
stopCluster(cl)
X_sel_final = select.idx(result.X)
scalar.X = scalar.x(X.selected, m)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
result.y <- foreach(i = 1:ncol(scalar.X)) %dopar% {
  step.multicop.y(i)
}
stopCluster(cl)
Y_sel_final = select.idx(result.Y)
# and you can get: 
print(paste0("My selected X features are:", X_sel_final))
print(paste0("My selected X features are:", Y_sel_final))
```

### Reference:
  - Zhong, Wenxuan, et al. "Correlation pursuit: forward stepwise variable selection for index models." Journal of the Royal Statistical Society Series B: Statistical Methodology 74.5 (2012): 849-870.


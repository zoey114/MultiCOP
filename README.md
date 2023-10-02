# MultiCOP - Variable selection for Multiresponse index model via correlation pursuit 


### Reference:
  - Zhong, Wenxuan, et al. "Correlation pursuit: forward stepwise variable selection for index models." Journal of the Royal Statistical Society Series B: Statistical Methodology 74.5 (2012): 849-870.

### Installation:
You can install the R package by:

```{r}
install.packages("MultiCOP")
```
### An example
1. Input data:
Multicop requires two data tables in matrix form as input, denoted as X and Y, each with dimensions of n_sample by n_feature.

2. Example:
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
x_sel_vote  <- Filter(function(x) !is.null(x), result.X)
num_elements <- sapply(x_sel_vote, length)
K_X <- as.integer(names(sort(table(num_elements), decreasing = TRUE)[1]))
freq_table <- table(unlist(x_sel_vote))
sorted_freq_table <- sort(freq_table, decreasing = TRUE)
X_sel_final <- names(sorted_freq_table[1:K_X])
X.selected = as.matrix(X[,X_sel_idx])
scalar.X = scalar.x(X.selected, m=1000)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
result.y <- foreach(i = 1:ncol(scalar.X)) %dopar% {
  step.multicop.y(i)
}
stopCluster(cl)
Y_sel_vote  <- Filter(function(x) !is.null(x), result.y)
num_elements <- sapply(x_sel_vote, length)
K_X <- as.integer(names(sort(table(num_elements), decreasing = TRUE)[1]))
freq_table <- table(unlist(Y_sel_vote))
sorted_freq_table <- sort(freq_table, decreasing = TRUE)
Y_sel_final <- names(sorted_freq_table[1:K_Y])
# And you can get:
print(paste0("My selected X features are:", X_sel_final))
print(paste0("My selected X features are:", Y_sel_final))
```

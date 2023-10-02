library(parallel)
library(foreach)
library(MASS)
library(dr)
source("R/utils.R")

scalar.Y = scalar.y(Y, m=m)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
result.X <- foreach(i = 1:ncol(scalar.Y)) %dopar% {
  step.multicop.x(i)
}
stopCluster(cl)
X_sel_final = select.idx(result.X)
scalar.X = scalar.x(X.selected, m=1000)
cl <- makeCluster(detectCores())
registerDoParallel(cl)
result.Y <- foreach(i = 1:ncol(scalar.X)) %dopar% {
  step.multicop.y(i)
}
stopCluster(cl)
Y_sel_final = select.idx(result.Y)
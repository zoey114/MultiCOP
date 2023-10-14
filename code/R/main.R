library(parallel)
library(foreach)
library(MASS)
library(dr)
source("R/utils.R")

scalar.Y = scalar(Y, m=m)
result.X = lapply(1:m, function(i){suppressWarnings(step.multicop.x(i))})
X_sub = select.idx(result.X)

X.selected = X[,as.numeric(X_sub)]
scalar.X = scalar(X.selected, m)
result.Y = lapply(1:m, function(i){suppressWarnings(step.multicop.y(i))})
Y_sub = select.idx(result.Y) 

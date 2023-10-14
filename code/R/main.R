library(parallel)
library(foreach)
library(MASS)
library(dr)
source("R/utils.R")

# alpha.in.list/alpha.out.list: vectors of candidate c_e and c_d. 
multicop = function(X, Y, alpha.in.list, alpha.out.list, m, my.range){
  sub = list()
  scalar.Y = scalar(Y, m=m)
  result.X = lapply(1:m, function(i){suppressWarnings(step.multicop.x(i))})
  X_sub = select.idx(result.X)
  X.selected = X[,as.numeric(X_sub)]
  scalar.X = scalar(X.selected, m)
  result.Y = lapply(1:m, function(i){suppressWarnings(step.multicop.y(i))})
  Y_sub = select.idx(result.Y) 
  sub[[1]] = X_sub
  sub[[2]] = Y_sub
  return(sub)
}

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

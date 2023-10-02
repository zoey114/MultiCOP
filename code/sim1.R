library(MASS)
library(dr)
setwd("/Users/zhenwang/Documents/new_MetaMeta/code/")
source("utils.R")
n = 100; p_x = 5; p_y = 6;
# for X 
rho = 0.5;
cov_X <- matrix(0, p_x, p_x)
for (i in 1:p_x) {
  for (j in 1:p_x) {
    cov_X[i, j] <- rho^abs(i - j)
  }
}
set.seed(123)  # for reproducibility
X <- mvrnorm(n, mu = rep(0, p_x), Sigma = cov_X)
# for Y
sigma <- 0.2
cov_epsilon <- matrix(0, p_y, p_y)
for (i in 1:p_y) {
  for (j in 1:p_y) {
    cov_epsilon[i, j] <- sigma^abs(i - j)
  }
}
epsilon <- mvrnorm(n, mu = rep(0, p_y), Sigma = cov_epsilon)
mat1 = matrix(c(3, 1.5, 2, 0, 0), nrow = 3, ncol = p_x, byrow = TRUE)
mat2 = matrix(c(0, 0, 0, 0, 0), nrow = (p_y-3), ncol = p_x, byrow = TRUE)
beta_matrix <- rbind(mat1,mat2)
Y <- X %*% t(beta_matrix) + epsilon
dim(X); dim(Y);

rep =1
alpha.in = 0.95;alpha.out = 0.90;my.range=100;m=1000
No.rep = rep
seed = rep*123
scalar.y <- function(Y, m){
  scalar_responses <- matrix(NA, n, m)
  # Generate random direction vectors and project Y along these directions
  for (i in 1:m) {
    # Generate a random direction vector with unit length
    #set.seed(seed+100)
    set.seed(123)
    direction <- rnorm(p_y)
    direction <- direction / sqrt(sum(direction^2))
    # Project Y along the direction vector
    scalar_responses[, i] <- Y %*% direction
  }
  return(scalar_responses)
}
scalar.Y = scalar.y(Y, m=m)
step.multicop.x <- function(i_y){
  tryCatch({
    x = X
    y = scalar.Y[,i_y]
    my.cop.sel = step.cop(x,y,H = 5,alpha.in = alpha.in,alpha.out = alpha.out,
                          my.range=my.range,k=3)
    # Select K, the number of principal profile correlation directions
    my.d=NULL
    for(j in 1:max(nrow(x),ncol(x))){
      my.cop.sel = step.cop(x,y,H = 5,alpha.in = alpha.in,alpha.out = alpha.out,
                            my.range=1000,k=j)
      my.cop.sel = c(1,2,3)
      for(j in 1:max(nrow(x),ncol(x))){
        # GIC<-function(x,y,my.sel,KK)
        my.d[j]=GIC(x,y,my.sel = my.cop.sel, KK = j)
        k_j = which.min(my.d)
      }
      
    }
    K = which.min(my.d)
    GIC_score = my.d[K]
    if (is.na(GIC_score)){print("no K is selected")}
    x_sel = step.cop(x,y,H = 5,alpha.in = 0.95,alpha.out = 0.90,my.range=100,k=K)
    return(x_sel)
    
  }, error = function(e) {
    cat("skip ",i_y, "\n")
  })
}
result.X = list()
for(i in 1:ncol(scalar.Y)){
  result.X[[i]] <- step.multicop.x(i)
}
x_sel_vote  <- Filter(function(x) !is.null(x), result.X)




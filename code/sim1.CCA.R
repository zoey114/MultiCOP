library(MASS)
library(dr)
library(changepoint)

## set simulation settings 
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



############ CCA ########
model <- cancor(X,Y)
print(model)

importance_scores <- abs(model$xcoef)
colnames(importance_scores) <- colnames(X)
# Sort features by importance
importance_scores_sorted <- importance_scores[order(-importance_scores)]
print(importance_scores_sorted)



library(MASS) 
library(caret) 
# Perform Canonical Correlation Analysis
cca_result <- cca(X, Y)
# Print canonical correlations
print(cca_result$cor)

library(PMA)
library(plyr)
library(boot)
library(rsample)
library(dplyr)

out <- CCA(X,Y,typex="standard",typez="standard",K=3)
print(out,verbose=TRUE)

cca_fit <- function(split, ...){
  df <- analysis(split)
  tax_df <- df %>% select(starts_with("SV")) 
  met_df <- df %>% select(!starts_with("SV"))
  perm <- CCA.permute(tax_df, met_df, typex = "standard", typez = "standard", 
                      nperms = 25, niter = 25, standardize = T)
  mod <- CCA(x = tax_df, z = met_df, typex = "standard", typez = "standard", penaltyx = perm$bestpenaltyx, 
             penaltyz = perm$bestpenaltyz, niter = 25, standardize = T)
  result <- mod$cors
  return(result)
  
}



cv <- CCA.permute(x = X, z = Y, typex = "standard", typez = "standard", 
                  nperms = 50, niter = 25, standardize = T)
cca <- CCA(x = X, z = Y, K = 1, penaltyx = cv$bestpenaltyx, 
           penaltyz = cv$bestpenaltyz, niter = 25)
cca
perm_test_cca <- function(X, Y, n_perms){
  null_corr <- c()
  for (i in 1:n_perms){
    rand_tax <- randomizeMatrix(tax, null.model = "richness", iterations = 1000) # one randomization
    rand_met <- randomizeMatrix(met, null.model = "richness", iterations = 1000)
    perm <- CCA.permute(x = rand_tax, z = rand_met, typex = "standard",typez = "standard", 
                        nperms = 50, niter = 25, standardize = T)
    cca_mod <- CCA(x = rand_tax, z = rand_met, typex = "standard", typez = "standard", 
                   niter = 25, penaltyx = perm$bestpenaltyx, 
                   penaltyz = perm$bestpenaltyz, standardize = T)
    null_corr[i] <- cca_mod$cors
  } 
  return(null_corr)
}  
perm_test <- perm_test_cca(Y, X, n_perms = 25)


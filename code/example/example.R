# We follow the scenario 1 in the paper to generate a data, saved in .txt files.
X = read.csv("input_X.txt")
Y = read.csv("input_Y.txt")
alpha.in = 0.95;alpha.out = 0.90;my.range=100;m=1000

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

print(paste0("My selected X features are:", X_sel_final))
print(paste0("My selected X features are:", Y_sel_final))
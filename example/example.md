### load data

    X = as.matrix(read.delim("input_X.txt", sep = ",",row.names=1))
    Y = as.matrix(read.csv("input_Y.txt", sep = ",",row.names=1))

    source("../code/R/utils.R")

    ## Loading required package: MASS

### selection of *X*

In this step, we implement the first stage in the MultiCOP algorithm to
select the variables in *X*. In COP step, we employ the cross-validation
procedure to select the threshold *c*<sub>*e*</sub> and
*c*<sub>*d*</sub>. The pool of possible *c*<sub>*e*</sub> is set as
{*χ*<sub>0.90, *K*</sub><sup>2</sup>,*χ*<sub>0.95, *K*</sub><sup>2</sup>,*χ*<sub>0.99, *K*</sub><sup>2</sup>},
and the associated pool of *c*<sub>*d*</sub> is set as
{*χ*<sub>0.85, *K*</sub><sup>2</sup>,*χ*<sub>0.90, *K*</sub><sup>2</sup>,*χ*<sub>0.95, *K*</sub><sup>2</sup>}.
We then select *K* from from 1 to 6 according to G information
criterion.

    my.range=100; m=100
    alpha.in.list = c(0.85,0.90,0.95)
    alpha.out.list = c(0.80, 0.85, 0.90) 
    scalar.Y = scalar(Y, m=m)
    result.X = lapply(1:m, function(i){suppressWarnings(step.multicop.x(i))})
    X_sub = select.idx(result.X)
    cat("The selected subset in X: ", X_sub, '\n')

    ## The selected subset in X:  1 2 3

### selection of *Y*

In this step, we implement the second stage in the MultiCOP algorithm to
select the variables in *Y*.

    X.selected = X[,as.numeric(X_sub)]
    scalar.X = scalar(X.selected, m)
    result.Y = lapply(1:m, function(i){suppressWarnings(step.multicop.y(i))})
    Y_sub = select.idx(result.Y)
    cat("The selected subset in Y: ", Y_sub, '\n')

    ## The selected subset in Y:  3 2 1

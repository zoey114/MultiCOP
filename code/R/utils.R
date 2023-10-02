step.cop<-function(x,y,H,alpha.in,alpha.out,my.range,k){
  x=as.matrix(x)		
  p=NCOL(x)
  n=nrow(x)
  if(k==1){
    lambdar=0
    aa=NULL
    for(j in 1:p){
      slice.1<-sapply(split(scale(x[,j]),as.factor(dr.slices(y,nslices=H)[[1]])),mean,simplify=TRUE)
      aa[j]<-var(slice.1)
    }
    lambdaf<-max(aa)
    id<-which.max(aa)
    cop<-n*(lambdaf-lambdar)/(1-lambdaf)
    if(cop>=qchisq(alpha.in,1)){
      my.current.sel=id
    }else{
      stop("There is no significant predictor!")
    }
  }else{
    my.current.sel=1:k
  }
  my.step=1			
  my.forward="conti"
  chi.in=qchisq(alpha.in,k)
  chi.out=qchisq(alpha.out,k)
  while(my.forward=="conti"&my.step<=my.range){		
    set.all<-1:p
    set.redundant<-setdiff(set.all,my.current.sel)
    pp=length(set.redundant)        
    if(length(my.current.sel)!=1){	   
      lambdar=dr(y~x[,my.current.sel],nslices=H)$evalues[1:k]
    }else{
      lambdar=lambdaf	
    }
    cop=lambdaf=NULL	  	
    for(j in 1:pp){
      ind1<-c(my.current.sel,set.redundant[j])
      xnew=x[,ind1]
      temp<-dr(y~xnew,nslices=H)
      lambdaf<-temp$evalues[1:k]
      cop[j]<-sum(n*(lambdaf-lambdar)/(1-lambdaf)) 	     	
    }
    cop.stata=max(cop[!is.na(cop)])	
    sel<-which(cop==cop.stata)[1]	
    if(cop.stata>=chi.in){
      my.forward="conti"
      my.current.sel<-c(my.current.sel,set.redundant[sel])
      my.backward="conti"
      while(my.backward=="conti"&length(my.current.sel)>2){
        pp=length(my.current.sel)
        cop=NULL
        for(l in 1:pp){
          ind1<-my.current.sel[-l]
          xfull=x[,my.current.sel]
          xreduce=x[,ind1]	
          temp1<-dr(y~scale(xfull),nslices=H)
          temp2<-dr(y~scale(xreduce),nslices=H)
          cop[l]<-sum(n*(temp1$evalues[1:k]-temp2$evalues[1:k])/(1-temp1$evalues[1:k]))
        }
        cop.statd=min(cop[!is.na(cop)])	
        sel<-which(cop==cop.statd)[1]
        if(cop.statd<=chi.out){
          my.backward="conti"
          my.current.sel<-my.current.sel[-sel]
        }else{
          my.backward="stop"
        }
      }
    }else{
      my.current.sel<-my.current.sel
      my.forward="stop"
    }
    my.step=length(my.current.sel)
  }	
  return(my.current.sel=my.current.sel)
}


GIC<-function(x,y,my.sel,KK){
  x1=x[,my.sel]
  p=ncol(x1)
  n=nrow(x1)
  phi=dr(y~x[,my.sel])$M
  omega=phi+diag(1,p)
  tao=length(eigen(omega)$values>1)
  ss=min(tao,KK)
  theta=eigen(omega)$values[(1+ss):p]
  logL=n/2*sum(log(theta)+1-theta)
  Gk=-(logL-2*KK*(log(n)*p-KK+1)/2)
  return(Gk)
}		


scalar.y <- function(Y, m){
  scalar_responses <- matrix(NA, n, m)
  # Generate random direction vectors and project Y along these directions
  for (i in 1:m) {
    # Generate a random direction vector with unit length
    set.seed(seed+100)
    direction <- rnorm(p_y)
    direction <- direction / sqrt(sum(direction^2))
    # Project Y along the direction vector
    scalar_responses[, i] <- Y %*% direction
  }
  return(scalar_responses)
}

scalar.x <- function(X.selected, m){
  scalar_responses <- matrix(NA, n, m)
  # Generate random direction vectors and project Y along these directions
  for (i in 1:m) {
    # Generate a random direction vector with unit length
    set.seed(seed+10)
    px = length(X_sel_idx)
    direction <- rnorm(px, mean=0, sd=1)
    direction <- direction / sqrt(sum(direction^2))
    # Project Y along the direction vector
    scalar_responses[, i] <- X.selected %*% direction
  }
  return(scalar_responses)
}

step.multicop.x <- function(i_y){
  tryCatch({
    x = X
    y = scalar.Y[,i_y]
    my.cop.sel = step.cop(x,y,H = 5,alpha.in = alpha.in,alpha.out = alpha.out,
                          my.range=my.range,k=3)
    # Select K, the number of principal profile correlation directions
    my.d=NULL
    for(j in 1:max(nrow(x),ncol(x))){
      # GIC<-function(x,y,my.sel,KK)
      my.d[j]=GIC(x,y,my.sel = my.cop.sel, KK = j)
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

step.multicop.y <- function(i_x){
  tryCatch({
    x = Y
    y = scalar.X[,i_x]
    my.cop.sel = step.cop(x,y,H = 5,alpha.in = 0.95,alpha.out = 0.90,
                          my.range=100,k=4)
    # Select K, the number of principal profile correlation directions
    my.d=NULL
    for(j in 1:max(nrow(x),ncol(x))){
      # GIC<-function(x,y,my.sel,KK)
      my.d[j]=GIC(x,y,my.sel = my.cop.sel, KK = j)
    }
    K = which.min(my.d)
    GIC_score = my.d[K]
    if (is.na(GIC_score)){print("no K is selected")}
    x_sel = step.cop(x,y,H = 5,alpha.in = 0.95,alpha.out = 0.90,my.range=100,k=K)
    return(x_sel)
    
  }, error = function(e) {
    cat("skip ",i_x, "\n")
  })
}

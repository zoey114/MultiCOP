library(Matrix) 
library(matrixcalc) 
library(expm) 
library(MASS)
library(dr)
library(rsample)
library(dplyr)


setClass(Class="aa",
         representation(
           M="matrix",
           eval="numeric",
           evec="matrix"
         )
)
pr=function(my.current.sel,y,mn,H){
  q = ncol(y)
  u = mvrnorm(n=mn, mu=rep(0,q), Sigma=diag(q))
  t = apply(u, 1, function(x) x/sqrt(sum(x^2))) # d: matrix: p*mn
  pr.sample = list()
  pr.M = list()
  not.sym.index = c()
  for(j in 1:mn){
    projected.y = y %*% t[,j]
    pr.sample[[j]] = cbind(x[,my.current.sel], projected.y)
    pr.M[[j]] = matrix()
    pr.M[[j]] = dr(projected.y~x[,my.current.sel], nslices=H)$M
    if(! isSymmetric(pr.M[[j]])){not.sym.index = c(not.sym.index, j)}
  }
  if(length(not.sym.index)!=0){pr.M = pr.M[-not.sym.index]}
  pr.M.avg = Reduce('+',pr.M)/mn
  pr.eigen = eigen(pr.M.avg)
  return(new("aa",
             M=pr.M.avg,
             eval=pr.eigen$values,
             evec=pr.eigen$vectors))
}

step.cop<-function(x,y,H,alpha.in,alpha.out,my.range,k,mn){
  x=as.matrix(x)
  p=ncol(x)
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
      lambdar=pr(my.current.sel,y,mn,H)@eval[1:k]
    }else{
      lambdar=lambdaf	
    }
    cop=lambdaf=NULL	  	
    for(j in 1:pp){
      ind1<-c(my.current.sel,set.redundant[j])
      lambdaf=pr(ind1,y,mn,H)@eval[1:k]
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
          ### to get lambdar from mn matrixes
          ind1<-my.current.sel[-l]
          cop[l]<-sum(n*(pr(my.current.sel,y,mn,H)@eval[1:k]-pr(ind1,y,mn,H)@eval[1:k])/
                        (1-pr(my.current.sel,y,mn,H)@eval[1:k]))
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

multi.GIC<-function(x,y,my.sel,KK){
  x1=x[,my.sel]
  p=ncol(x1)
  n=nrow(x1)
  phi = pr(my.sel,y,mn,H)@M
  omega=phi+diag(1,p) 
  tao=length(eigen(omega)$values>1)
  ss=min(tao,KK) #KK: specify the candidate number of principle directions, KK is smaller than k 
  theta=eigen(omega)$values[(1+ss):p]
  logL=n/2*sum(log(theta)+1-theta)
  Gk=-(logL-2*KK*(log(n)*p-KK+1)/2)
  return(Gk)
}		

#This function calculate the K-fold CV 
#for selecting the optimal variable-in and variable-out threshold in correlation pursuit method
multi.cop.cv<-function(x,y,my.sel,K.fold,KK,H,mn){
  set.seed(1234)
  n=nrow(x)
  my.label<-rmultinom(n,1,prob=rep(1,K.fold)/K.fold)
  #	while(min(apply(my.label,1,sum))>2){
  #	 my.label<-rmultinom(n,1,prob=rep(1,K.fold)/K.fold)
  #	}
  my.sel.ind=my.sel
  x=as.matrix(x[,my.sel.ind])
  p=ncol(x)
  my.cv<-NULL
  for(k in 1:K.fold){
    xtest=x[my.label[k,]==1,]
    xtrain=x[my.label[k,]!=1,]
    ytest=y[my.label[k,]==1]
    ytrain=y[my.label[k,]!=1]
    train=data.frame(ytrain=ytrain,xtrain=xtrain)
    # beta.hat=dr(ytrain~xtrain,data=train)$evectors[,1:KK]
    beta.hat=pr(my.label[k,]!=1, ytrain, mn, H)@evec[,1:KK]
    my.dim.cv=NULL		
    if(KK==1){
      temp=xtrain%*%beta.hat
      if(sum(is.na(my.pred))!=0){
        my.del=which(is.na(my.pred))
        test=list(my.pred=my.pred[-my.del],xtest=xtest[-my.del,])
      }else{
        test=list(my.pred=my.pred,xtest=xtest)
      }
      my.dim.cv=cor(test[[1]], as.vector(test[[2]]%*%beta.hat))
    }else{
      for(m in 1:KK){	
        temp=xtrain%*%beta.hat[,m]
        my.fit=loess(temp~ytrain,data=train)
        my.pred=predict(my.fit,data.frame(ytrain=ytest))
        if(sum(is.na(my.pred))!=0){
          my.del=which(is.na(my.pred))
          test=list(my.pred=my.pred[-my.del],xtest=xtest[-my.del,])
        }else{
          test=list(my.pred=my.pred,xtest=xtest)
        }				
        my.dim.cv[m]=cor(test[[1]], as.vector(test[[2]]%*%beta.hat[,m]))^2			
      }			
    }
    print(my.dim.cv)
    my.cv[k]=sum(my.dim.cv)
  }
  K.CV=sum(my.cv)
  return(K.CV)	
}		

# This function calculate the selected subset. 
multi.step.cop<-function(x,y,H,alpha.in,alpha.out,my.range,k){
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





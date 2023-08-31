p=4; q=6; p0=2; q0=3;
rho=0.5; sigma=0.1;
n=100
Sigma.x = matrix(nrow=p,ncol=p)
for(i in 1:p){
  for(j in 1:p){
    Sigma.x[i,j]=rho**abs(i-j)
  }
}
Sigma.e = matrix(nrow=q,ncol=q)
for(i in 1:q){
  for(j in 1:q){
    Sigma.e[i,j]=sigma**abs(i-j)
  }
}
x = mvrnorm(n, rep(0,p), Sigma.x)
e = mvrnorm(n, rep(0,q), Sigma.e)
y = matrix(nrow=n, ncol=q)
for(i in 1:3){
  y[,i]=(x[,1]+x[,2])/(0.5+(1.5+x[,1])*(1.5+x[,1]))+e[,i]
}
for(i in 4:q){
  y[,i] = e[,i]
}

#### test ######
alpha.in=c(0.9,0.95,0.99)
i=1
my.cop.sel=list()
while(i <=3){
  my.cop.sel[[i]]<-step.cop(x,y,5,alpha.in[i],alpha.in[i]-0.05,4,2,1500)
  i=i+1
}
# my.d=NULL
# for(i in 1:3){
#   my.d[i]=GIC(x,y,my.cop.sel[[i]],i)
# }
# my.d
alpha.in=c(0.9,0.95,0.99)
i=1
my.cop.sel.y=list()
while(i <=3){
  my.cop.sel.y[[i]]<-step.cop(y,x[,my.cop.sel[[i]]],5,alpha.in[i],alpha.in[i]-0.05,6,3,1500)
  i=i+1
}

# Fit an additive Bayesian network to data

Take a subset of cols from dataset ex0.dat.data:

```r
mydat <- ex0.dag.data[,c("b1","b2","b3","g1","b4","p2","p4")]
```

Setup distribution list for each node 

```r
mydists <- list(b1="binomial",
b2="binomial", 
b3="binomial", 
g1="gaussian", 
b4="binomial",
p2="poisson", 
p4="poisson" )
```

Define model 

```r
mydag <- matrix(data=c( 0,0,1,0,0,0,0, # b1<-b3 
1,0,0,0,0,0,0, # b2<-b1 
0,0,0,0,0,0,0, # 
0,0,0,0,1,0,0, # g1<-b4 
0,0,0,0,0,0,0, # 
0,0,0,0,0,0,0, # 
0,0,0,0,0,0,0 # 
), byrow=TRUE,ncol=7)

colnames(mydag) <- rownames(mydag) <- names(mydat)
```

Fit the model to calculate the log marginal likelihood goodness of fit

```r
myres.c <- fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists)

print(myres.c$mlik)
```

# Examine the parameter estimates in additive Bayesian network

Take a subset of cols from dataset ex0.dat.data

```r
mydat <- ex0.dag.data[,c("b1","b2","b3","g1","b4","p2","p4")]
```

Setup distribution list for each node 

```r
mydists <- list(b1="binomial", 
b2="binomial", 
b3="binomial", 
g1="gaussian", 
b4="binomial", 
p2="poisson", 
p4="poisson")
```

Define a model 

```r
mydag <- matrix(data=c(
0,0,1,0,0,0,0, # b1<-b3 
1,0,0,0,0,0,0, # b2<-b1 
0,0,0,0,0,0,0, # 
0,0,0,0,1,0,0, # g1<-b4 
0,0,0,0,0,0,0, # 
0,0,0,0,0,0,0, # 
0,0,0,0,0,0,0 #
), byrow=TRUE,ncol=7)
colnames(mydag) <- rownames(mydag) <- names(mydat)
```

Now fit the model to calculate its goodness of fit

```r
myres.c <- fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists,compute.fixed=TRUE)

print(names(myres.c$marginals))
```

Gives a list of all the posterior densities. Plot some of the marginal posterior densities - note by default all variables are standarized. 

```r
par(mfrow=c(1,2))
plot(myres.c$marginals$b1[["b1|(Intercept)"]],type="b",xlab="b1|(Intercept)", main="Node b1, Intercept",pch="+",col="green")

plot(myres.c$marginals$g1[["g1|b4"]],type="b",xlab="g1|b4",main="Node g1, parameter b4",pch="+",col="orange")
```

# Find the best fitting graphical structure for an additive Bayesian network using an exact search
# Find the best fitting graphical structure for an additive Bayesian network using a heuristic search
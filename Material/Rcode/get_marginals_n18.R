## source("header_code.R"); ## not needed - this only works on fraser's machine with the C source code
library(abn);
library(Cairo);
mydat<-ex5.dag.data[,-19];

############################################################################################
## Estimate all posterior estimates from a given DAG
############################################################################################
## Step 1. Define the DAG
############################################################################################
## fit model GLOBAL BEST SCORE DAG - this is mp.dag.4 
## write out manually since its clearer than using rep()
mydag<-matrix(c(
     # b1  b2  b3  b4  b5  b6  g1  g2  g3  g4  g5  g6  g7  g8  g9 g10 g11 g12
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  0,  0,  1, # b1
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0, # b2
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0, # b3
       0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  0,  0,  0, # b4
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0, # b5
       0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # b6
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g1
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  0,  0,  0, # g2
       0,  0,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g3
       0,  0,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g4
       0,  0,  1,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0, # g5
       0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1, # g6
       0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0, # g7
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0, # g8
       0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0, # g9
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0, # g10
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g11
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0),# g12
       byrow=TRUE,ncol=18);

colnames(mydag)<-rownames(mydag)<-names(mydat);## needed

## use fitabn just to check mydag is correct (no typos as mlik should = -8323.939
## setup distribution list for each node
mydists<-list(b1="binomial",
              b2="binomial",
              b3="binomial",
              b4="binomial",
              b5="binomial",
              b6="binomial",
              g1="gaussian",
              g2="gaussian",
              g3="gaussian",
              g4="gaussian",
              g5="gaussian",
              g6="gaussian",
              g7="gaussian",
              g8="gaussian",
              g9="gaussian",
              g10="gaussian",
              g11="gaussian",
              g12="gaussian"              
             );

print(fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists)$mlik);## ok. have correct model

#################################################################################################
### now compute marginals for each and every parameter in the model
#################################################################################################
## with compute.fixed=TRUE this tries to estimate the posterior densities. Note that the
## algorithm used to locate the x values is very crude and it may be better to provide these
## manually in some case. Using n.grid=1000 uses a fine grid of 1000 points. 
## this works well here for the "sensible" variables but terrible for the "bad" variables

marg.f<-fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists,compute.fixed=TRUE,n.grid=1000);#, marginal.node=1,marginal.param=1,variate.vec=seq(-150,5,len=1000),verbose=TRUE);

library(Cairo);
CairoPDF("margplots.pdf");
for(i in 1:length(marg.f$marginals)){
plot(marg.f$marginals[[i]],type="l",main=names(marg.f$marginals)[[i]]);
}
dev.off();

## node b1 looks weird so re-do the strange dist with manually chosen intervals (trial and error end points)
marg.b1.1<-fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists,compute.fixed=TRUE,marginal.node=1,marginal.param=1,variate.vec=seq(-150,5,len=1000));
marg.b1.3<-fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists,compute.fixed=TRUE,marginal.node=1,marginal.param=3,variate.vec=seq(-60,5,len=1000));
marg.b1.4<-fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists,compute.fixed=TRUE,marginal.node=1,marginal.param=4,variate.vec=seq(-5,20,len=1000));
marg.b1.5<-fitabn(dag.m=mydag,data.df=mydat,data.dists=mydists,compute.fixed=TRUE,marginal.node=1,marginal.param=5,variate.vec=seq(-100,20,len=1000));

## now add these into the original set of marginals - use names(marg.f$marginals) to see which is which
marg.f$marginals[[1]]<-marg.b1.1$marginals[[1]];
marg.f$marginals[[3]]<-marg.b1.3$marginals[[1]];
marg.f$marginals[[4]]<-marg.b1.4$marginals[[1]];
marg.f$marginals[[5]]<-marg.b1.5$marginals[[1]];

## re-do the plot
library(Cairo);
CairoPDF("margplots2.pdf");
for(i in 1:length(marg.f$marginals)){
plot(marg.f$marginals[[i]],type="l",main=names(marg.f$marginals)[[i]]);
}
dev.off();

## how reliable are the marginals? If the numerical routines work well then the area under the density function should be 
## close to unity (but not exact due to rounding errors). Note also that values closer to unity might be achived by
## give a custom range using variate.vec.

myarea<-rep(NA,length(marg.f$marginals));names(myarea)<-names(marg.f$marginals);
for(i in 1:length(marg.f$marginals)){
    tmp<-spline(marg.f$marginals[[i]]);## spline just helps make the estimation smoother
    myarea[i]<-sum(diff(tmp$x)*tmp$y[-1]);## just width x height of rectangles
}

## now visualise as a plot
library(Cairo);
mycols<-rep("green",length(marg.f$marginals));mycols[1:5]<-"red";mycols[17]<-"orange";
CairoPNG("fig1n.png",pointsize=10,width=720,height=640);#
par(las=2);
par(mar=c(8.1,4.1,4.1,2.1));
barplot(myarea,ylab="Area under Density",ylim=c(0,2),col=mycols);
dev.off();

## all seems fine except for node b1, and possibly node b6.

## lets seem what glm says
mydat2<-mydat;## make a copy of the data
## have to manually standardise the Gaussian nodes (since that it what fitabn does)
for(i in 7:18){mydat2[,i]<-(mydat2[,i]-mean(mydat2[,i]))/sd(mydat2[,i]);}
## now see what glnm gives for the modes and standard errors
summary(m1<-glm(b1~g7+g8+g9+g12,data=mydat2,family="binomial"));

##Coefficients:
##            Estimate Std. Error z value Pr(>|z|)
##  (Intercept)  -231.61   28087.99  -0.008    0.993
##  g7            -88.31   13076.94  -0.007    0.995
##  g8            -89.26   11767.74  -0.008    0.994
##  g9             25.64    3172.98   0.008    0.994
##  g12           -43.02    9689.96  -0.004    0.996
## The standard errors are MASSIVE. E.g. the estimation is just not relaible
## not also the warning from glm about non-convergence. 
print(marg.f$modes$b1);
## the estimated modes from fitabn also differ greatly here from glm (whose results are not reliable either)
## Looking at the data shows that there are only 2 "successes" observed for b1
## against 432 failures. This variable should probably have been removed at the start
## due to a lack of observations. We now drop this since.
## In short the marginals for this node cannot be reliably estimated as is.

## the second lesser issue was with node b6.
## again try glm
summary(m1<-glm(b6~b4,data=mydat2,family="binomial"));
##Coefficients:
##            Estimate Std. Error z value Pr(>|z|)    
##(Intercept)   -1.827      0.144 -12.688   <2e-16 ***
## b41          -15.739    722.296  -0.022    0.983  
## Again a MASSIVE standard error but no warning from glm. 
## Unlike the posterior densities for b1 the intercept is fine
print(marg.f$modes$b6);## the estimated mode for the intercept is almost identica to glm. All good.
plot(marg.f$marginals[["b6|(Intercept)"]],type="l");abline(v=marg.f$modes$b6[1]);
## what about the second parameter? Its mode is different from glm -15 v -6 but well within the
## standard error and this simply suggests the distribution is probably poorly defined (e.g. v.wide)
plot(marg.f$marginals[["b6|b4"]],type="l");abline(v=marg.f$modes$b6[2],col="blue");
## the real difficulty here is the zero cell in the 2x2 table
table(mydat$b6,mydat$b4):
##      0   1
##  0 348  30
##  1  56   0
## which means that b4 can only have a negative effect on the prob of success! In which case the mle
## estimation is probably going to struggle given this 0 count. All in all the density estimates
## for this node seem ok to include in the bootstrapping. 

## one final point. We could always estimate the marginals using INLA. 
marg.first<-fitabn.inla(dag.m=mydag,data.df=mydat,data.dists=mydists,compute.fixed=TRUE);
## looking at the results for node 1
plot(marg.first$marginals[[1]]);## etc
## INLA is also completely different from glm and may be unreliable, we cannot be sure.
## Using INLA for node b6 is also interesting.
plot(marg.first$marginals[["b6|(Intercept)"]],type="l",col="red");
lines(marg.f$marginals[["b6|(Intercept)"]],col="blue"); 
## almost identical to fitabn. But what about b6|b4
plot(marg.first$marginals[["b6|b4"]],type="l",col="red",xlim=c(-130,20));
lines(marg.f$marginals[["b6|b4"]],col="blue"); 
## INLA is clearly wrong here - about a 1/3 - 1/4 of the posterior density is to the right of zero 
## which seems very dubious sense. The model for this node falls into a type of problem which INLA is known
## not to handle very well (see website) as it is really designed  for use with latent variable models. 
## In short the fitabn() results for this node look ok and what we will use in the bootstrapping.



## source("header_code.R"); ## this only works on fraser's machine with the C source code
library(abn);
library(Cairo);
mydat<-ex5.dag.data[,-c(1,19)];

############################################################################################
## Estimate all posterior estimates from a given DAG
############################################################################################
## Step 1. Define the DAG
############################################################################################
## fit model GLOBAL BEST SCORE DAG - this is mp.dag.4 
## write out manually since its clearer than using rep()
mydag<-matrix(c(
     # b2  b3  b4  b5  b6  g1  g2  g3  g4  g5  g6  g7  g8  g9 g10 g11 g12
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0, # b2
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0, # b3
       0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  1,  0,  0,  0, # b4
       0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0, # b5
       0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # b6
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g1
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  0,  0,  0, # g2
       0,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g3
       0,  1,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g4
       0,  1,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0, # g5
       0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1, # g6
       0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0, # g7
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0, # g8
       0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0, # g9
       0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  0,  0,  0,  0,  0,  0, # g10
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, # g11
       0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0),# g12
       byrow=TRUE,ncol=17);

colnames(mydag)<-rownames(mydag)<-names(mydat);## needed

## use fitabn just to check mydag is correct (no typos as mlik should = -8323.939
## setup distribution list for each node
mydists<-list(
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
CairoPDF("margplots_n17.pdf");
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
cbind(myarea);

### b6|b4 is still a little large but is probably fine just hard to estimate well given the certainty involved.
## jags will re-standardize anyway so this is not a problem really.                                            


## now create the data for going to JAGS.
print(names(marg.f$marginals));## want to bind all the marginals the same nodes into a matrix
m<-marg.f$marginals;## less typing

b2.p<-cbind(m[["b2|(Intercept)"]],m[["b2|g6"]]);
b3.p<-cbind(m[["b3|(Intercept)"]],  m[["b3|g8"]]);
b4.p<-cbind(  m[["b4|(Intercept)"]],  m[["b4|b3"]],           m[["b4|g6" ]],          m[["b4|g9"]]);           
b5.p<-cbind(m[["b5|(Intercept)"]],  m[["b5|g5" ]]);
b6.p<-cbind(m[["b6|(Intercept)"]],  m[["b6|b4"]]);
g1.p<-cbind(m[["g1|(Intercept)"]]);
prec.g1.p<- m[["g1|precision"]];
g2.p<-cbind(m[["g2|(Intercept)"]],  m[["g2|g6"]],          m[["g2|g8"]]);
 prec.g2.p<-          m[["g2|precision"]];
g3.p<-cbind( m[["g3|(Intercept)"]],  m[["g3|b3"]],          m[["g3|g2"]]);
  prec.g3.p<-         m[["g3|precision"]];
g4.p<-cbind(m[["g4|(Intercept)"]],m[["g4|b3"]],          m[["g4|g2"]]);
 prec.g4.p<-          m[["g4|precision"]];
g5.p<-cbind(m[["g5|(Intercept)"]],  m[["g5|b3"]],          m[["g5|b6"]],           m[["g5|g9"]]);
 prec.g5.p<-          m[["g5|precision"]];
g6.p<-cbind(m[["g6|(Intercept)"]],  m[["g6|g1"]],           m[["g6|g11"]],          m[["g6|g12"]]);
 prec.g6.p<-         m[["g6|precision"]];
g7.p<-cbind( m[["g7|(Intercept)"]],  m[["g7|b3"]],           m[["g7|g9"]]);
 prec.g7.p<-          m[["g7|precision"]];
g8.p<-cbind(m[["g8|(Intercept)"]],  m[["g8|g11"]]);
 prec.g8.p<-         m[["g8|precision"]];
g9.p<-cbind(m[["g9|(Intercept)"]],  m[["g9|g2"]],           m[["g9|g6"]]);
 prec.g9.p<-          m[["g9|precision"]];
g10.p<-cbind(m[["g10|(Intercept)"]], m[["g10|g5"]]); 
prec.g10.p<-         m[["g10|precision"]];
g11.p<-cbind(m[["g11|(Intercept)"]]);
prec.g11.p<- m[["g11|precision"]];
g12.p<-cbind(m[["g12|(Intercept)"]]);
prec.g12.p<- m[["g12|precision"]];

dump(c("b2.p","b3.p","b4.p","b5.p","b6.p",
       "g1.p", "g2.p", "g3.p", "g4.p", "g5.p", "g6.p", "g7.p", "g8.p", "g9.p", "g10.p", "g11.p", "g12.p",
"prec.g1.p","prec.g2.p","prec.g3.p","prec.g4.p","prec.g5.p","prec.g6.p","prec.g7.p","prec.g8.p","prec.g9.p","prec.g10.p","prec.g11.p","prec.g12.p"),
file="post_params.R");



                                                      
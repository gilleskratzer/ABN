####################################################################################
##### Last part - compute marginals for this best model
####################################################################################
## this is as above
load("bestdag_trim.RData");#provides bestdag.trim
library(abn);
library(Cairo);
mydat<-ex5.dag.data[,-c(1,19)];

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

## compute marginals
marg.f<-fitabn(dag.m=bestdag.trim,data.df=mydat,data.dists=mydists,compute.fixed=TRUE,n.grid=1000);#,

library(Cairo);
CairoPDF("postbootplots.pdf");
for(i in 1:length(marg.f$marginals)){
plot(marg.f$marginals[[i]],type="l",main=names(marg.f$marginals)[[i]]);
}
dev.off();


## now for a table of quantiles
margs<-marg.f$marginals;
mymat<-matrix(rep(NA,length(margs)*3),ncol=3);rownames(mymat)<-names(margs);colnames(mymat)<-c("2.5%","50%","97.5%");
ignore.me<-union(grep("\\(Int",names(margs)),grep("prec",names(margs)));## these are not effect parameters - background constants and precisions
comment<-rep("",length(margs));
for(i in 1:length(margs)){
 tmp<-margs[[i]];
 tmp2<-cumsum(tmp[,2])/sum(tmp[,2]);
mymat[i,]<-c(tmp[which(tmp2>0.025)[1]-1,1],## -1 is so use value on the left of the 2.5% 
             tmp[which(tmp2>0.5)[1],1],
             tmp[which(tmp2>0.975)[1],1]);
  myvec<-mymat[i,];

  if( !(i%in%ignore.me) &&  (myvec[1]<0 && myvec[3]>0)){comment[i]<-"not sig. at 5%";} 

## truncate for printing
mymat[i,]<-as.numeric(formatC(mymat[i,],digits=3,format="f"));
}
cbind(comment);


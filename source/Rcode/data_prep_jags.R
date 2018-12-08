library(abn);
mydat<-ex5.dag.data[,-1];## keep the group this time

## need to get the data in a suitable format for JAGS
## coerce all the binary variables from factors to 0/1 numbers 
## coerce the group factor into numeric to get integers group IDs
## IMPORTANT NOTE - we are standarising the Gaussian variables here as is done in all previous analyses and is a good thing in terms of computationally accuracy
## standarising has absolutely no effect on statistical signficance but obviously does affect the estimates of effect size 


for(i in 1:dim(mydat)[2]){
                       if(   is.factor(mydat[,i])
                          && names(mydat)[i]!="group"){## have a factor and its not the grouping variable
                                                       mydat[,i]<-ifelse(mydat[,i]==levels(mydat[,i])[1],0,1);## first level gets 0, second level gets 1
                      } else {if(!is.factor(mydat[,i])
                          && names(mydat)[i]!="group"){## have a continuous variable so standarise
                                                      mydat[,i]<-(mydat[,i]-mean(mydat[,i]))/sd(mydat[,i]);}
                             }
}
mydat$group<-as.numeric(mydat$group);## from factor to integer

attach(mydat);
N<-dim(mydat)[1];## number of obs
M<-max(group);## number of groups

## now send all the data needed to a file in format suitable for reading into jags
dump(c("N","M",names(mydat)),file="data.jags");

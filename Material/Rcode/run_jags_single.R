
library(abn);
orig.data<-ex5.dag.data[,-c(1,19)];

## now create a single bootstrap sample

system("jags jags_script.R");
## read in boot data and convert to data.frame in same format as the original data
## e.g. coerce to factors
library(coda);
boot.data<-read.coda("out1chain1.txt","out1index.txt");
boot.data<-as.data.frame(boot.data);
for(j in 1:dim(orig.data)[2]){if(is.factor(orig.data[,j])){boot.data[,j]<-as.factor(boot.data[,j]);
                                                 levels(boot.data[,j])<-levels(orig.data[,j]);}}

## now have the boot.data in identical format to original to now repeat exact search.
banned<-matrix(c(
                    #   1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
         		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b2
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b3
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b4
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b5
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b6
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g1
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g2
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g3
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g4
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g5
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g6
         		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g7
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g8
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g9
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g10
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g11
         		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  # g12
                                           ),byrow=TRUE,ncol=17);
                  
colnames(banned)<-rownames(banned)<-names(orig.data);## ignore group variable

retain<-matrix(c( 
                    #   1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
         		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b2
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b3
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b4
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b5
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b6
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g1
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g2
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g3
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g4
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g5
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g6
         		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g7
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g8
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g9
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g10
                        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g11
         		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  # g12
                                           ),byrow=TRUE,ncol=17);  
                   
colnames(retain)<-rownames(retain)<-names(orig.data);## ignore group variable


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

## parent limits - only needs to be 3 single this is all the original data used
max.par<-3;
## now build cache 
boot1.cache<-buildscorecache(data.df=orig.data,data.dists=mydists,
                           max.parents=max.par,centre=TRUE);

boot1.mp<-mostprobable(score.cache=boot1.cache);

save(boot1.mp,file="boot1.RData");


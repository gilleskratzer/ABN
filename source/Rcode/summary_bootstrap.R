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
bestdag<-mydag;
#############################################################################################
## read ALL files with mp[number].RData and create one list of results.
boot.dags<-list();
these<-grep("mp\\d+.RData",dir());
num<-1;
for(i in dir()[these]){#load each file
load(i);#provides dags - a list
tmp<-dags[which(unlist(lapply(dags,sum))>0)];#get valid entries in dags but as a list
for(j in 1:length(tmp)){#for each entry copy into boot.dags, and increment counter
                        boot.dags[[num]]<-tmp[[j]];num<-num+1;}
rm(dags);
}

### have a look at the mlik values for the bootstraps viz a viz the original 
if(FALSE){
scores<-rep(0,length(boot.dags));for(i in 1:length(boot.dags)){scores[i]<-fitabn(dag.m=boot.dags[[i]],data.df=mydat,data.dists=mydists)$mlik;}
scores.b<-scores[-which(scores< -10000)];
orig.score<-fitabn(dag.m=bestdag,data.df=mydat,data.dists=mydists)$mlik;
plot(density(scores.b,from=min(scores.b),to=max(scores.b)))
abline(v=orig.score,lwd=2,col="blue")

}

## trim all arcs from the boot results which do not occur in the Master DAG - bestdag - since we know these are due to overfitting!
boot.dags.trim<-boot.dags;
for(i in 1:length(boot.dags)){
boot.dags.trim[[i]]<-boot.dags.trim[[i]]*bestdag;
}

arc.freq<-lapply(boot.dags.trim,sum);arc.freq<-table(unlist(arc.freq));#a<-a[-1]; #drop all null results
library(Cairo);
CairoPNG("bootres1.png",pointsize=10,width=720,height=640);#
par(las=1);
par(mar=c(6.1,6.1,4.1,2.1));
barplot(arc.freq,ylab="",xlab="",col="skyblue",names.arg=names(arc.freq),ylim=c(0,1600));
par(las=1);
#axis(1,at=seq(1,22,by=1));
mtext("No. of arcs in bootstrap DAG",1,line=3,cex=1.5);
par(las=3);
mtext("Frequency out of 10000",2,line=4,cex=1.5)
dev.off();


#### now for some trimming
total.dag<-matrix(rep(0,dim(bestdag)[2]^2),ncol=dim(bestdag)[2]);colnames(total.dag)<-rownames(total.dag)<-colnames(bestdag);
## get support for each arc - total.dag
for(i in 1:length(boot.dags)){
if(sum(boot.dags[[i]])>0){total.dag<-total.dag+boot.dags[[i]];}}  ##if is a hack in case some of the entries are empty e.g. cluster crash.
total.dag<-total.dag*bestdag;##since only want arcs in the best DAG

## get the majority consensus - directed DAG
f<-function(val,limit){if(val<limit){return(0);} else {return(1);}}
bestdag.trim<-apply(total.dag,c(1,2),FUN=f,limit=5000);


## get the majority consensus - undirected DAG - but with arcs in the most supported direction

bestdag.trim.nodir<-bestdag;
bestdag.trim.nodir[,]<-0;## set zero
child<-NULL;parent<-NULL;
for(i in 1:dim(total.dag)[1]){
 for(j in 1:dim(total.dag)[2]){
     if(i>j){
              ## get most supported direction
              if(total.dag[i,j]>total.dag[j,i]){m.i<-i;m.j<-j;} else {m.i<-j;m.j<-i;}
              ## does arc quality - exceed threshold of support
              if(total.dag[i,j]+total.dag[j,i]>5000){## we want this as more than 5000
                                                     bestdag.trim.nodir[m.i,m.j]<-1;}
}}}

### NOTE. bestdag.trim and bestdag.trim.nodir are the SAME

tographviz(dag.m=bestdag.trim,data.df=mydat,data.dists=mydists,outfile="postboot.dot");
#system("dot -Tpdf -o postboot.pdf postboot.dot");system("evince postboot.pdf");
system("dot -Tpng -o postboot.png postboot.dot");
save(bestdag.trim,file="bestdag_trim.RData");




index<-1;
###########################################################################################
# order based searches
#############################################################################################

library(abn);
library(coda);
orig.data<-ex5.dag.data[,-c(1,19)];
max.par<-3;#parent limit for original data
start<-seq(1,1000,by=5);
stop<-seq(5,1000,by=5);

## SET BAN LIST - note only banning split variables - nothing more
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

dags<-list();
#########################################
for(i in start[index]:stop[index]){ #MASTER LOOP - each interation creates a bootstrap sample and finds mostprobable model
#########################################
  #create bootstrap data
   #1. create parameter file with unique random seed
   init.file<-paste("init_",i,sep="");#tempfile(pattern=paste("_",index,"_",sep=""),tmpdir=getwd());#file to hold jags seed
   cat(paste("\".RNG.name\" <-\"base::Mersenne-Twister\"","\n",sep=""),file=init.file,append=FALSE);
   cat(paste("\".RNG.seed\" <- ",i,"\n",sep=""),file=init.file,append=TRUE);#note i is unique
   #2. create script file with unique output file name
   run.file<-paste("script_",i,sep="");#tempfile(pattern=paste("_",index,"_",sep=""),tmpdir=getwd());#file to hold jags seed

#this is needed verbatim     
cat("model in model.bug
data in post_params.R
compile, nchains(1)
",file=run.file);
cat(paste("parameters in ",init.file,"\n",sep=""),file=run.file,append=TRUE);
cat("initialize
update 100000
monitor b2, thin(10)
monitor b3, thin(10)
monitor b4, thin(10)
monitor b5, thin(10)
monitor b6, thin(10)
monitor g1, thin(10)
monitor g2, thin(10)
monitor g3, thin(10)
monitor g4, thin(10)
monitor g5, thin(10)
monitor g6, thin(10)
monitor g7, thin(10)
monitor g8, thin(10)
monitor g9, thin(10)
monitor g10, thin(10)
monitor g11, thin(10)
monitor g12, thin(10)
update 4340, by(1000)
",file=run.file,append=TRUE);
   out.file<-paste("out_",i,sep="");
   cat(paste("coda *, stem(\"",out.file,"\")\n",sep=""),file=run.file,append=TRUE);
 
#3. run the MCMC sampler
   #system(paste("/home/vetadm/flewis/bin/jags ",run.file,sep=""));
   system(paste("jags ",run.file,sep=""));
   #4. read in mcmc data and convert to format suitable for mostprobable
   boot.data<-read.coda(paste(out.file,"chain1.txt",sep=""),paste(out.file,"index.txt",sep=""));
   boot.data<-as.data.frame(boot.data);
   for(j in 1:dim(orig.data)[2]){if(is.factor(orig.data[,j])){boot.data[,j]<-as.factor(boot.data[,j]);
                                                 levels(boot.data[,j])<-levels(orig.data[,j]);}}

   #5. run the MostProb search on the bootstrap data
  boot1.cache<-buildscorecache(data.df=boot.data,data.dists=mydists, max.parents=max.par,centre=TRUE);
   dags[[i]]<-mostprobable(score.cache=boot1.cache);
   unlink(c(init.file,run.file,out.file,paste(out.file,"chain1.txt",sep=""),paste(out.file,"index.txt",sep="")));#tidy up
}

save(dags,file=paste("mp",index,".RData",sep=""));



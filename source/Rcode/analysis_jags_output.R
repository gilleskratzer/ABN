#####################################################################################
# best DAG after bootstrapping
load("bestdag_trim.RData"); #provides bestpostboot
library(abn);
mydat<-ex5.dag.data[,-c(1)];## the observed data
#####################################################################################
# 2. analyse mcmc output
## analyse data from JAGS
library(coda);
sim.dat1<-read.coda("out1chain1.txt","out1index.txt");
sim.dat2<-read.coda("out2chain1.txt","out2index.txt");
sim.dat3<-read.coda("out3chain1.txt","out3index.txt");
sim.dat4<-read.coda("out4chain1.txt","out4index.txt");
sim.dat5<-read.coda("out5chain1.txt","out5index.txt");
sim.dat6<-read.coda("out6chain1.txt","out6index.txt");
sim.dat7<-read.coda("out7chain1.txt","out7index.txt");
sim.dat8<-read.coda("out8chain1.txt","out7index.txt");
sim.dat9<-read.coda("out9chain1.txt","out9index.txt");
sim.dat10<-read.coda("out10chain1.txt","out10index.txt");
sim.dat11<-read.coda("out11chain1.txt","out11index.txt");
sim.dat12<-read.coda("out12chain1.txt","out12index.txt");
sim.dat13<-read.coda("out13chain1.txt","out13index.txt");
sim.dat14<-read.coda("out14chain1.txt","out14index.txt");
sim.dat15<-read.coda("out15chain1.txt","out15index.txt");
sim.dat16<-read.coda("out16chain1.txt","out16index.txt");

## check just a few for convergence, couple in intercepts plus some variance terms
check<-mcmc.list(sim.dat1[,"g1.c0"],sim.dat2[,"g1.c0"],sim.dat3[,"g1.c0"],sim.dat4[,"g1.c0"],
                 sim.dat5[,"g1.c0"],sim.dat6[,"g1.c0"],sim.dat7[,"g1.c0"],sim.dat8[,"g1.c0"],
                 sim.dat9[,"g1.c0"],sim.dat10[,"g1.c0"],sim.dat11[,"g1.c0"],sim.dat12[,"g1.c0"],
                 sim.dat13[,"g1.c0"],sim.dat14[,"g1.c0"],sim.dat15[,"g1.c0"],sim.dat16[,"g1.c0"]);
plot(check);


check<-mcmc.list(sim.dat1[,"b5.c0"],sim.dat2[,"b5.c0"],sim.dat3[,"b5.c0"],sim.dat4[,"b5.c0"],
                 sim.dat5[,"b5.c0"],sim.dat6[,"b5.c0"],sim.dat7[,"b5.c0"],sim.dat8[,"b5.c0"],
                 sim.dat9[,"b5.c0"],sim.dat10[,"b5.c0"],sim.dat11[,"b5.c0"],sim.dat12[,"b5.c0"],
                 sim.dat13[,"b5.c0"],sim.dat14[,"b5.c0"],sim.dat15[,"b5.c0"],sim.dat16[,"b5.c0"]);
plot(check);


check<-mcmc.list(sim.dat1[,"prec.g2"],sim.dat2[,"prec.g2"],sim.dat3[,"prec.g2"],sim.dat4[,"prec.g2"],
                 sim.dat5[,"prec.g2"],sim.dat6[,"prec.g2"],sim.dat7[,"prec.g2"],sim.dat8[,"prec.g2"],
                 sim.dat9[,"prec.g2"],sim.dat10[,"prec.g2"],sim.dat11[,"prec.g2"],sim.dat12[,"prec.g2"],
                 sim.dat13[,"prec.g2"],sim.dat14[,"prec.g2"],sim.dat15[,"prec.g2"],sim.dat16[,"prec.g2"]);
plot(check);

check<-mcmc.list(sim.dat1[,"prec.rv.g4"],sim.dat2[,"prec.rv.g4"],sim.dat3[,"prec.rv.g4"],sim.dat4[,"prec.rv.g4"],
                 sim.dat5[,"prec.rv.g4"],sim.dat6[,"prec.rv.g4"],sim.dat7[,"prec.rv.g4"],sim.dat8[,"prec.rv.g4"],
                 sim.dat9[,"prec.rv.g4"],sim.dat10[,"prec.rv.g4"],sim.dat11[,"prec.rv.g4"],sim.dat12[,"prec.rv.g4"],
                 sim.dat13[,"prec.rv.g4"],sim.dat14[,"prec.rv.g4"],sim.dat15[,"prec.rv.g4"],sim.dat16[,"prec.rv.g4"]);
plot(check);

check<-mcmc.list(sim.dat1[,"prec.g4"],sim.dat2[,"prec.g4"],sim.dat3[,"prec.g4"],sim.dat4[,"prec.g4"],
                 sim.dat5[,"prec.g4"],sim.dat6[,"prec.g4"],sim.dat7[,"prec.g4"],sim.dat8[,"prec.g4"],
                 sim.dat9[,"prec.g4"],sim.dat10[,"prec.g4"],sim.dat11[,"prec.g4"],sim.dat12[,"prec.g4"],
                 sim.dat13[,"prec.g4"],sim.dat14[,"prec.g4"],sim.dat15[,"prec.g4"],sim.dat16[,"prec.g4"]);
plot(check);

## this all seems fine.


mcmc.all<-mcmc.list(sim.dat1,sim.dat2,sim.dat3,sim.dat4,sim.dat5,sim.dat6,sim.dat7,sim.dat8,sim.dat9,sim.dat10,sim.dat11,sim.dat12,sim.dat13,sim.dat14,sim.dat15,sim.dat16);
   
all<-rbind(sim.dat1,sim.dat2,sim.dat3,sim.dat4,sim.dat5,sim.dat6,sim.dat7,sim.dat8,sim.dat9,sim.dat10,sim.dat11,sim.dat12,sim.dat13,sim.dat14,sim.dat15,sim.dat16);
   
## we want the marginal densities for the arcs and so give the relevant parameter sensible names.

## b2   0  0  0  0  0  0  0  0  0  0  1  0  0  0   0   0   0 # b2|g6
## b3   0  0  0  0  0  0  0  0  0  0  0  0  1  0   0   0   0 # b3|g8
## b4   0  1  0  0  0  0  0  0  0  0  1  0  0  1   0   0   0 # b4|b3:g6:g9
## b5   0  0  0  0  0  0  0  0  0  1  0  0  0  0   0   0   0 # b5|g5
## b6   0  0  1  0  0  0  0  0  0  0  0  0  0  0   0   0   0 # b6|b4:
## g1   0  0  0  0  0  0  0  0  0  0  0  0  0  0   0   0   0 # g1|
## g2   0  0  0  0  0  0  0  0  0  0  1  0  1  0   0   0   0 # g2|g6:g8
## g3   0  1  0  0  0  0  1  0  0  0  0  0  0  0   0   0   0 # g3|b3:g2:
## g4   0  0  0  0  0  0  1  0  0  0  0  0  0  0   0   0   0 # g4|g2
## g5   0  1  0  0  0  0  0  0  0  0  0  0  0  1   0   0   0 # g5|b3:g9
## g6   0  0  0  0  0  1  0  0  0  0  0  0  0  0   0   1   0 # g6|g1:g11
## g7   0  1  0  0  0  0  0  0  0  0  0  0  0  0   0   0   0 # g7|b3
## g8   0  0  0  0  0  0  0  0  0  0  0  0  0  0   0   1   0 # g8|g11
## g9   0  0  0  0  0  0  0  0  0  0  1  0  0  0   0   0   0 # g9|g6
## g10  0  0  0  0  0  0  0  0  0  1  0  0  0  0   0   0   0 # g10|g5
## g11  0  0  0  0  0  0  0  0  0  0  0  0  0  0   0   0   0 # g11|
## g12  0  0  0  0  0  0  0  0  0  0  0  0  0  0   0   0   0 # g12|

## below 30 is the first "slope" parameter - see script.R file for the order

colnames(all)[18]<-"g1|precision";
colnames(all)[19]<-"g2|precision"; 
colnames(all)[20]<-"g3|precision";
colnames(all)[21]<-"g4|precision";
colnames(all)[22]<-"g5|precision"; 
colnames(all)[23]<-"g6|precision";
colnames(all)[24]<-"g7|precision";
colnames(all)[25]<-"g8|precision"; 
colnames(all)[26]<-"g9|precision";
colnames(all)[27]<-"g10|precision";
colnames(all)[28]<-"g11|precision";
colnames(all)[29]<-"g12|precision"; 
colnames(all)[30]<-"b2|(Intercept)";      
colnames(all)[31]<-"b2|g6";
colnames(all)[32]<-"b3|(Intercept)";
colnames(all)[33]<-"b3|b8";
colnames(all)[34]<-"b4|(Intercept)";
colnames(all)[35]<-"b4|b3";
colnames(all)[36]<-"b4|g6";
colnames(all)[37]<-"b4|g9";
colnames(all)[38]<-"b5|(Intercept)";
colnames(all)[39]<-"b5|g5";
colnames(all)[40]<-"b6|(Intercept)";
colnames(all)[41]<-"b6|b4";
colnames(all)[42]<-"g1|(Intercept)";
colnames(all)[43]<-"g2|(Intercept)";
colnames(all)[44]<-"g2|g6";
colnames(all)[45]<-"g2|g8";
colnames(all)[46]<-"g3|(Intercept)";
colnames(all)[47]<-"g3|b3";
colnames(all)[48]<-"g3|g2";
colnames(all)[49]<-"g4|(Intercept)";
colnames(all)[50]<-"g4|g2";
colnames(all)[51]<-"g5|(Intercept)";
colnames(all)[52]<-"g5|b3";
colnames(all)[53]<-"g5|g9";
colnames(all)[54]<-"g6|(Intercept)";
colnames(all)[55]<-"g6|g1";
colnames(all)[56]<-"g6|g11";
colnames(all)[57]<-"g7|(Intercept)";
colnames(all)[58]<-"g7|b3";
colnames(all)[59]<-"g8|(Intercept)";
colnames(all)[60]<-"g8|g11";
colnames(all)[61]<-"g9|(Intercept)";
colnames(all)[62]<-"g9|g6";
colnames(all)[63]<-"g10|(Intercept)";
colnames(all)[64]<-"g10|g5";
colnames(all)[65]<-"g11|(Intercept)";
colnames(all)[66]<-"g12|(Intercept)";

reorder<-c(30:41,42,18,44:45,19,46:48,20,49:50,21,51:53,22,54:56,23,57:58,24,59:60,25,61:62,26,63:64,27,65,28,66,29);
all.cp<-all[,reorder];
## get quantiles
myres<-t(apply(all.cp,2,quantile,probs=c(0.025,0.5,0.975)));

for(i in 1:dim(myres)[1]){
myres[i,]<-as.numeric(formatC(myres[i,],format="f",digits=3));

}



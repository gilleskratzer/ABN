# Overview

This case study uses data set `ex5.dag.data` provided with [abn](https://CRAN.R-project.org/package=abn) which comprises of 434 observations across 18 variables, 6 binary and 12 continuous, and one grouping variable.

Variables b1 and b2 were formed by taking a variable with three categories and splitting it into two binary variables. To include such multinomial variables in [abn](https://CRAN.R-project.org/package=abn) one must first split these variables into separate binary variables, e.g. each denoting categories such as *{Yes, Not Yes}*, *{No, Not No}*, *{Dont Know, Not Dont Know}* etc. This is more flexible than usual nominal regression since other variables can now have completely different effects on each different category (as opposed to something like a proportional odds assumption). This does, however, have two consequences:
1. it can greatly add to the dimension of the model which can be a limiting factor
2. when performing any model selection we must ban any arcs from being considered between the split variables as these are not “real” dependencies but simply structural artifacts. This can be easily achieved through giving a ban matrix to the relevant functions (see below).

This data has a grouping variable. This means that the observations within each group (e.g. household or farm) may be correlated, and therefore potentially causing the distribution of the data for any particular covariate pattern to be over-dispersed relative to standard sampling distributions (e.g. binomial or Gaussian sampling). The usual way to deal with this would be to move from using generalised linear models at each node to generalised linear mixed models at each node. As yet, such functionality is not available within [abn](https://CRAN.R-project.org/package=abn) (it is for binary nodes but this is still largely experimental and nothing is implemented for correlated data at Gaussian nodes). There is a relatively straightforward workaround – we simply ignore the grouping effects during the model searching and then apply an appropriate adjustment to the final chosen model, where this may result in trimming some arcs from the model. This adjustment is to correct for the fact that our model may not be sufficiently conservative as the usual impact of ignoring correlation effects is an under-estimation of variance. Therefore, resulting in potential over-modelling – our model may have more structure (arcs) than could reasonably be supported given the available data. There is some argument that this “post-correction” approach may in fact be a better solution, as dealing directly with DAGs comprising of mixed models is vastly more computationally demanding, and the numerics involved are always far more approximate than when random effects are not involved. This correction will be performed using MCMC in JAGS/WinBUGS (see later).

# Deciding on a search method

As a very rough rule of thumb if there are less than 20 variables (and no random effects) then probably the most robust model search option is an exact search (as opposed to a heuristic) which will identify a globally best DAG. Followed then by parametric bootstrapping in order to assess whether the identified model contains excess structure (this is an adjustment for over-modelling). Although, the parametric bootstrapping might require access to a cluster computer to make this computationally feasible. This is arguably one of the most comprehensive and reliable statistical modelling approaches for identifying an empirically justified best guess (DAG) at “nature’s true model” – the unknown mechanisms and processes which generated the study data.

# Preparing the data

There are two main things which need to be checked in the data before it can be used with any of the [abn](https://CRAN.R-project.org/package=abn) model fitting functions.

1. All records with missing variables must be either removed or imputed. There is a range of libraries available from CRAN for completing missing values using approaches such as multiple imputation. Ideally, marginalising over the missing values is preferable (as opposed completing them as this then results in essentially dealing with models of models), but this is far from trivial here and not yet (and may never be) implemented in [abn](https://CRAN.R-project.org/package=abn). To remove all records with one or more missing values then code similar to the following probably suffices
`ex5.dag.data[complete.cases(ex5.dag.data),]`

2. All variables which are to be treated as binary must be coerced to factors. To coerce an existing variable into a factor then
`ex5.dag.data[,1]<-as.factor(ex5.dag.data[,1])` coerces the first variable in data.frame `ex5.dag.data`. The levels (labels of the factor) can be anything provided there are only two and a *success* here is take to be the second level. For example, the second value in the vector returned by
`levels(ex5.dag.data[,1])`

To include additional variables in the modeling, for example interaction terms or polynomials, then these must be created manually and included into the data.frame just like any other variable.

# Initial searches for a optimal model

Below is some R code which will perform an exact search using a parent limit of at most one parent per node. Similar code can be used to perform searches for higher parent limits (similar code can be downloaded from a link further down this page).

```r
library(abn)
mydat <- ex5.dag.data[,-19] ## get the data - drop group variable 
```

Create a matrix of banned arcs. Row are children, columns parents. The first row says do not allow arc b1<-b2. Second row is similar and says do not allow b2<-b1. These banned arcs are for the split variables. The ban matrix must be a named matrix.

```r
banned<-matrix(c(
# 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b1
1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b2
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b3
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b4
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b5
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b6
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g2
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g3
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g4
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g5
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g6
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g7
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g8
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g9
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g10
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g11
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 # g12
),byrow=TRUE,ncol=18)

colnames(banned)<-rownames(banned)<-names(mydat);
```

The retain matrix is not constrained i.e a zero matrix (one could also use `NULL`).

```r
retain<-matrix(c(
# 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b2
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b3
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b4
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b5
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # b6
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g1
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g2
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g3
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g4
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g5
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g6
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g7
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g8
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g9
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g10
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, # g11
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 # g12
),byrow=TRUE,ncol=18)
## again must set names
colnames(retain)<-rownames(retain)<-names(mydat)
```

Set up distribution list for each node

```r
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
)
```

Build a cache of all the local computations and perform an exact search.

```r
mycache.1par <- buildscorecache(data.df=mydat,data.dists=mydists, max.parents=1,centre=TRUE)

mp.dag <- mostprobable(score.cache=mycache.1par)
```

We want to find the DAG with the best goodness of fit (network score - log marginal likelihood) and ideally we would search for this without any a priori complexity limit (max number of parents). However, this may be both not computationally feasible and also highly inefficient. For example, with 434 observation is it really realistic to consider models with up to 17 covariates per node? One heuristic approach is to start off with an a priori limit of one parent per node, find the best DAG, and then repeat an identical search process (again using functions `buildscorecache()` and `mostprobable()`) with an increasing parent limit. Then stopping when the network score reach a plateau.

These initial searches can be parallelised, although whether this is worth the extra hassle depends on how many variables are present and what computing facilities are available. The run time for the `mostprobable()` function increases very considerably with the number of parents. The abn library does not include any implicit parallelisation. While it lacks the conceptual elegance of multi-threading, simply task farming jobs on separate cpus using R CMD BATCH is by far the most computationally efficient solution here. This can also easily be achieved on a cluster via an MPI C wrapper (e.g. run many parallel R CMD BATCH jobs). Many systems use MPI and as such some standard code can be used here (but there is usually a local submission script required for the scheduling engine).

Sample code which can be used on a cluster to parallelise searches for parent limits 2 through 9 can be found [here](material/Rcode/search_code.tar.gz). This comprises of 8 R scripts plus an MPI C wrapper (which needs to be compiled on the cluster using an appropriate compiler like mpicc). The compiled wrapper is the program actually submitted to the cluster. I used 8 different parent limits here as the cluster I use is built from compute nodes of 8 cores each and so it makes most sense to run parallel tasks in multiples of 8. I could have ran parent limits 1 through 16 but this is likely wasteful since I don’t expect the data to support so many parents.

### Results


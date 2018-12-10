# Introduction

Here we present ten case study analyses which are used to validate the robustness and accuracy of the implementation of the numerical methods used in [abn](https://CRAN.R-project.org/package=abn). In each case real data are utilized comprising of extracts sourced from (published and unpublished) research studies in medicine and biology, as opposed to simulated data, although all variable names have been anonymized. In an attempt to avoid re-inventing the wheel, [abn](https://CRAN.R-project.org/package=abn) has wrappers to allow [INLA](http://www.r-inla.org/) to be used for model fitting. In addition [abn](https://CRAN.R-project.org/package=abn) has its own internal numerical routines, because as we demonstrate across the ten case studies below, for some data sets and models (node-parent combinations) [INLA](http://www.r-inla.org/) does not perform at all well and so an alternative is essential when performing structure discovery.

While the focus of [abn](https://CRAN.R-project.org/package=abn) is on structure discovery i.e. identifying optimal DAGs amongst the vast number of different possible DAG structures, it is obviously first essential to estimate a reliable goodness of fit metric for each candidate DAG. For this we use the standard metric in the Bayesian netowrk literature, the log marginal likelihood (mlik), where this is estimated via Laplace approximations (e.g. [Journal of the American Statistical Association](https://amstat.tandfonline.com/doi/abs/10.1080/01621459.1986.10478240#.XA4ZhRNKi1s)).

The core feature of the [abn](https://CRAN.R-project.org/package=abn) R library is that it should be able to provide robust model comparison of DAGs comprising of nodes which are parameterized as generalized linear models (glm) or generalized linear mixed models (glmm) . Based on results from the following case studies the default setting in [abn](https://CRAN.R-project.org/package=abn) is to use internal [abn](https://CRAN.R-project.org/package=abn) code for glm nodes. There is no obvious speed advantage here in using calls to [INLA](http://www.r-inla.org/), indeed the reverse is true in a number of cases, and the internal code seems more robust for the types of models implemented in [abn](https://CRAN.R-project.org/package=abn). For glmm nodes the default is to use [INLA](http://www.r-inla.org/), as it is very considerably faster than the internal code, however, [INLA](http://www.r-inla.org/)’s results appear unreliable for a considerable minority of the modelling results examined in the following case studies. For this reason results from [INLA](http://www.r-inla.org/) are only used if its estimated parameter modes are sufficiently similar to those from internal code (which are fast and easy to estimate). If this “validity check” fails then internal code is used instead. The choice of internal or [INLA](http://www.r-inla.org/) can be set by the user.

In the following case studies, mlik values and parameter estimates are compared between the internal [abn](https://CRAN.R-project.org/package=abn) code and those from [INLA](http://www.r-inla.org/). Also utilized are established (non-Bayesian) model fitting routines in R, such as *glm()* and *glmer()*, where the latter is from the [lme4](https://CRAN.R-project.org/package=lme4) extension library. The point estimates (modes) from *glm()* and *glmer()* here serve as gold standard estimates of the modes used in the Laplace approximation for the Bayesian models with highly diffuse priors.

# QA Case Studies for GLM Nodes

**QA Study One – glm nodes**

This study involves analyses of data set *ex2.dag.data* (provided with abn) and we estimate log marginal likelihoods (mlik) for 18 nodes (variables) allowing at most two parents per node in the DAG. This requires estimating mlik values across 2772 different glm nodes comprising (assumed) Gaussian, binary and Poisson distributed variables. We compare the estimated values for mlik between the internal abn code and INLA. As we do not have a gold standard against which to check the mlik values, we compare the estimated parameter modes against R’s *glm()* function.

The data, results and R code used to run this study can be found [here](source/Rcode/QA_glm_case1.tar.gz). Figure one shows that while there is generally excellent agreement between the abn internal code and INLA there are 45 of the 2772 mlik values which are really quite different.

![](Material/Plot/QA_glm_case1_fig1.png)

For the 45 mlik values whose relative (absolute) difference between abn and INLA was at least 1% we then fitted these nodes individually, and for each compared the parameter modes with output from glm(). Some of these results are given below.

```r

################ bad= 1 ###################

# 1. glm()
(Intercept) p5
3.1045344 0.5277181

# 2. C
b1|(Intercept) b1|p5
3.1045205 0.5277251

# 3. INLA
b1|(Intercept) b1|p5
1.952409008 0.001948155

###########################################
################ bad= 2 ###################

# 1. glm()
(Intercept) p1 p5
3.1657652 -0.1492764 0.5483882

# 2. C
b1|(Intercept) b1|p1 b1|p5
3.1657479 -0.1492691 0.5483910

# 3. INLA
b1|(Intercept) b1|p1 b1|p5
1.9519098549 0.0007641673 0.0019274231

###########################################
....
################ bad= 45 ##################

# 1. glm()
(Intercept) p5 p6
0.89968810 0.06765933 -0.01727257

# 2. C
b6|(Intercept) b6|p5 b6|p6
0.89968746 0.06765934 -0.01727251

# 3. INLA
b6|(Intercept) b6|p5 b6|p6
0.922178660 0.012382561 -0.004336884

############################################

```
**QA Study Two – glm nodes**
**QA Study three – glm nodes**
**QA Study Four – glm nodes**

# QA Case Studies – GLMM Nodes
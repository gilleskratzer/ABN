# Introduction

Here we present ten case study analyses which are used to validate the robustness and accuracy of the implementation of the numerical methods used in [abn](https://CRAN.R-project.org/package=abn). In each case real data are utilized comprising of extracts sourced from (published and unpublished) research studies in medicine and biology, as opposed to simulated data, although all variable names have been anonymized. In an attempt to avoid re-inventing the wheel, [abn](https://CRAN.R-project.org/package=abn) has wrappers to allow [INLA](http://www.r-inla.org/) to be used for model fitting. In addition [abn](https://CRAN.R-project.org/package=abn) has its own internal numerical routines, because as we demonstrate across the ten case studies below, for some data sets and models (node-parent combinations) [INLA](http://www.r-inla.org/) does not perform at all well and so an alternative is essential when performing structure discovery.

While the focus of [abn](https://CRAN.R-project.org/package=abn) is on structure discovery i.e. identifying optimal DAGs amongst the vast number of different possible DAG structures, it is obviously first essential to estimate a reliable goodness of fit metric for each candidate DAG. For this we use the standard metric in the Bayesian netowrk literature, the log marginal likelihood (mlik), where this is estimated via Laplace approximations (e.g. [Journal of the American Statistical Association](https://amstat.tandfonline.com/doi/abs/10.1080/01621459.1986.10478240#.XA4ZhRNKi1s)).

The core feature of the [abn](https://CRAN.R-project.org/package=abn) R library is that it should be able to provide robust model comparison of DAGs comprising of nodes which are parameterized as generalized linear models (glm) or generalized linear mixed models (glmm) . Based on results from the following case studies the default setting in [abn](https://CRAN.R-project.org/package=abn) is to use internal [abn](https://CRAN.R-project.org/package=abn) code for glm nodes. There is no obvious speed advantage here in using calls to [INLA](http://www.r-inla.org/), indeed the reverse is true in a number of cases, and the internal code seems more robust for the types of models implemented in [abn](https://CRAN.R-project.org/package=abn). For glmm nodes the default is to use [INLA](http://www.r-inla.org/), as it is very considerably faster than the internal code, however, [INLA](http://www.r-inla.org/)’s results appear unreliable for a considerable minority of the modelling results examined in the following case studies. For this reason results from [INLA](http://www.r-inla.org/) are only used if its estimated parameter modes are sufficiently similar to those from internal code (which are fast and easy to estimate). If this “validity check” fails then internal code is used instead. The choice of internal or [INLA](http://www.r-inla.org/) can be set by the user.

In the following case studies, mlik values and parameter estimates are compared between the internal [abn](https://CRAN.R-project.org/package=abn) code and those from [INLA](http://www.r-inla.org/). Also utilized are established (non-Bayesian) model fitting routines in R, such as *glm()* and *glmer()*, where the latter is from the [lme4](https://CRAN.R-project.org/package=lme4) extension library. The point estimates (modes) from *glm()* and *glmer()* here serve as gold standard estimates of the modes used in the Laplace approximation for the Bayesian models with highly diffuse priors.

___

# QA Case Studies for GLM Nodes

**QA Study One – glm nodes**

This study involves analyses of data set *ex2.dag.data* (provided with abn) and we estimate log marginal likelihoods (mlik) for 18 nodes (variables) allowing at most two parents per node in the DAG. This requires estimating mlik values across 2772 different glm nodes comprising (assumed) Gaussian, binary and Poisson distributed variables. We compare the estimated values for mlik between the internal abn code and INLA. As we do not have a gold standard against which to check the mlik values, we compare the estimated parameter modes against R’s *glm()* function.

The data, results and R code used to run this study can be found [here](source/Rcode/QA_glm_case1.tar.gz). Fig.1 shows that while there is generally excellent agreement between the abn internal code and INLA there are 45 of the 2772 mlik values which are really quite different.

![](Material/Plot/QA_glm_case1_fig1.png)
*Figure 1*

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

In each and every of the 45 cases where the error was “large”, the modes estimated from INLA output were radically different from those produced by glm(). In contrast, the abn internal code gave a very close match to glm() in each and every case. When the modes from INLA were similar to *glm()* then the mlik values were virtually identical. This suggests that the internal code is robust in this example.

___

**QA Study Two – glm nodes**

This study involves analyses of data set ex5.dag.data which is provided with abn and we estimate log marginal likelihoods (mlik) for 18 nodes (variables) allowing at most four parents per node in the DAG. This requires estimating mlik values across 56458 different glm nodes comprising (assumed) Gaussian, and binary distributed variables.

The data, results and R code used to run this study can be found [here](source/Rcode/QA_glm_case2.tar.gz). Fig. 2 shows that while there is generally excellent agreement between abn internal code and INLA there are some 363 of the 56458 mlik values which are very different.

![](Material/Plot/QA_glm_case2_fig1.png)
*Figure 2*

To examine possible reasons for the differences we fit each node individually and check against results from glm(). We find that in each and every case the reason for the difference is that the model at each node is effectively over-parameterized (linearly dependent covariates), i.e. the residual deviance is zero. The internal code does the right thing here – it gives a massively low mlik value for the node, for this data somewhere around -1E+24, and so the model will never be chosen as a preferred model. Unfortunately, INLA here appears to do the reverse, the mlik values it provides are outliers but in the wrong direction. For these same node and parent combinations the mlik from INLA is much larger (more positive) than any other parent combinations for the same node. For example at node g2, then model g2=g1+g12 has mlik=-479.9385, g2=g3+g4 has mlik=1905.106, and g2=g3+g5 has mlik=-644.1653. The variables g3 and g4 are effectively linearly dependent (glm gives a residual deviance of zero) but here INLA gives a better mlik value when this should really be either missing or highly negative. Each of the 363 mlik values which differ between INLA and the internal code are due to this reason, some examples are given below. Note that the total mlik for DAG (below) assumes that the other nodes in the DAG are independent and is given to show that the mlik for the single node being examined is an outlier.

```r
################ bad= 1 #################

# 1. glm()
(Intercept) g3 g4
-8.631182e-16 8.981593e-01 -7.014127e-01
# residual deviance from glm()
[1] 1.475444e-27

# 2. C
g2|(Intercept) g2|g3 g2|g4 g2|precision
-1.044357e-15 8.981593e-01 -7.014127e-01 3.713778e+28
mlik for node= -1.856889e+24
total mlik for DAG= -1.856889e+24

# 3. INLA
g2|(Intercept) g2|g3 g2|g4 g2|precision
-5.189404e-07 8.981588e-01 -7.014133e-01 4.821793e+05
mlik for node= 1905.106
total mlik for DAG= -6170.889

###########################################
################ bad= 2 ###################

# 1. glm()
(Intercept) b11 g3 g4
-8.725460e-16 2.045840e-15 8.981593e-01 -7.014127e-01
# residual deviance from glm()
[1] 4.063515e-27

# 2. C
g2|(Intercept) g2|b1 g2|g3 g2|g4 g2|precision
-1.080299e-15 7.716050e-15 8.981593e-01 -7.014127e-01 3.840625e+28
mlik for node= -1.920313e+24
total mlik for DAG= -1.920313e+24

# 3. INLA
g2|(Intercept) g2|b1 g2|g3 g2|g4 g2|precision
-5.201857e-07 -7.696000e-06 8.981588e-01 -7.014133e-01 4.720212e+05
mlik for node= 1895.87
total mlik for DAG= -6180.124

###########################################
.....
################ bad= 363 #################

# 1. glm()
(Intercept) g2 g3 g11 g12
-1.230542e-15 -1.425694e+00 1.280500e+00 1.409431e-17 3.367973e-17
# residual deviance from glm()
[1] 1.283874e-27

# 2. C
g4|(Intercept) g4|g2 g4|g3 g4|g11 g4|g12
-1.488933e-15 -1.425694e+00 1.280500e+00 3.016250e-16 3.677614e-16
g4|precision
2.533905e+28
mlik for node= -1.266952e+24
total mlik for DAG= -1.266952e+24

# 3. INLA
g4|(Intercept) g4|g2 g4|g3 g4|g11 g4|g12
-5.190096e-07 -1.425695e+00 1.280500e+00 -5.218569e-07 -5.235011e-07
g4|precision
4.718762e+05
mlik for node= 1881.607
total mlik for DAG= -6194.388

###########################################
```

This case study suggests that for this glm type data the internal code is reliable, and also does the sensible thing when faced with a model which is over-parameterized and gives it an extremely poor mlik. Using INLA is rather more problematic here as while it agrees with all but the 363 cases, it is less clear how to catch this sort of error as the modes in each case are a reasonably good match and so that cannot be used to switch from INLA to internal code.

___

**QA Study three – glm nodes**

This study involves analyses of data set ex6.dag.data which is provided with abn and we estimate log marginal likelihoods (mlik) for 7 nodes (variables) allowing at most three parents per node in the DAG. This requires estimating mlik values across 294 different glm nodes comprising four Gaussian, two binary and a single Poisson distributed variable.

The data, results and R code used to run this study can be found [here](source/Rcode/QA_glm_case3.tar.gz). Fig. 3 shows that while there is generally excellent agreement between abn internal code and INLA there are some 42 of the 294 mlik values whose relative error, while still very small is higher than for the remaining comparisons.

![](Material/Plot/QA_glm_case3_fig1.png)
*Figure 3*

To examine possible reasons for the slightly higher – although still very small – differences in the mlik estimates for the Poisson node we fit each node individually and check against results from *glm()*.

```r

################ bad= 1 #################

# 1. glm()
(Intercept)
2.04866

# 2. C
p1|(Intercept)
2.04866

# 3. INLA
p1|(Intercept)
2.048619

###########################################
################ bad= 2 ###################

# 1. glm()
(Intercept) g1
1.9827638 -0.3747767

# 2. C
p1|(Intercept) p1|g1
1.9827634 -0.3747768

# 3. INLA
p1|(Intercept) p1|g1
1.9826424 -0.3748008

###########################################
....
################ bad= 42 ##################

# 1. glm()
(Intercept) b2no g3 g4
1.07381236 1.07368150 -0.03414610 -0.01012696

# 2. C
p1|(Intercept) p1|b2 p1|g3 p1|g4
1.07381238 1.07368130 -0.03414607 -0.01012696

# 3. INLA
p1|(Intercept) p1|b2 p1|g3 p1|g4
1.07631002 1.07358110 -0.03418459 -0.01021941

###########################################

```

In each and every comparison the modes estimated using the internal code and also INLA are virtually indistinguishable from those using *glm()*, although generally those from the internal code are rather closer to those from *glm()*. This does not help explain why the relative differences for the Poisson node should be slightly larger than for the Gaussian or binary nodes but in any case the mlik values are very close. This may simply be due to differing numerical accuracies used in each approach. This case study suggests that for this glm type data the internal code is reliable.

___

**QA Study Four – glm nodes**

This case study uses the data set Epil which is provided as part of the INLA library and comprises two parts. First we examine DAGs comprising of three variables, a Poisson, a binary and a Gaussian variable. The data, results and R code used to run this study can be found [here](source/Rcode/QA_glm_case4A.tar.gz). Fig.4  shows that while there is excellent agreement between abn internal code and INLA, as in case study three there is a slightly higher – although still very small – relative difference for the Poisson node than the binary or Gaussian nodes.

![](Material/Plot/QA_glm_case4_fig1.png)
*Figure 4*

We now repeat this analyses but where we multiply the values of the count variable, Epil$y, by 100. This is a somewhat arbitrary figure but as R’s *glm()* has no trouble with this it is not unreasonable to expect abn to also fit this model. Fig. 5 shows that the internal code and INLA completely disagree on mlik values for this new data set.

![](Material/Plot/QA_glm_case4_fig2.png)
*Figure 5*

To examine more closely a possible reason for such a discrepancy we compare the parameter modes from *glm()*, internal code and INLA.

```r

# 1. glm()
(Intercept)
6.715897

# 2. C
y|(Intercept)
6.715897

# 3. INLA
y|(Intercept)
78.62504

###########################################
################ bad= 2 ###################

# 1. glm()
(Intercept) Trt1
6.75464572 -0.07508706

# 2. C
y|(Intercept) y|Trt
6.75464565 -0.07508699

# 3. INLA
y|(Intercept) y|Trt
81.002154 -4.572519

###########################################
################ bad= 3 ###################

# 1. glm()
(Intercept) Age
6.71286815 -0.07831446

# 2. C
y|(Intercept) y|Age
6.71286812 -0.07831447

# 3. INLA
y|(Intercept) y|Age
78.628716 -6.708889

###########################################
################ bad= 4 ###################

# 1. glm()
(Intercept) Trt1 Age
6.76040114 -0.09251375 -0.08347222

# 2. C
y|(Intercept) y|Trt y|Age
6.76040107 -0.09251368 -0.08347222

# 3. INLA
y|(Intercept) y|Trt y|Age
81.832478 -6.162349 -7.056603

###########################################

```

In each case above the modes estimated from INLA are completely different – and therefore assumed incorrect – compared to glm(). The internal code is virtually identical to *glm()*. This suggests that the internal code is reliable. In terms of INLA, as with the above case studies, INLA can give very misleading results but which seems to be possible to identify fairly easily by comparing its modes with either the internal code or *glm()*.

===


# QA Case Studies – GLMM Nodes

**QA Study One – glmm nodes**
**QA Study Two – glmm nodes**
**QA Study Three – glmm nodes**
**QA Study Four – glmm nodes**
**QA Study Five – glmm nodes**
**QA Study Six – glmm nodes**
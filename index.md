# Introduction

Bayesian network modelling is a data analysis technique which is ideally suited to messy, complex data. This methodology is rather distinct from other forms of statistical modelling in that its focus is on **structure discovery** – determining an optimal graphical model which describes the inter-relationships in the underlying processes which generated the study data. It is, by construction, a **multivariate** technique and can used for one or many dependent variables. The key point of note here is that such graphical models are derived empirically from observed data, as opposed to, for example, relying only on subjective expert opinion to determine how variables of interest are inter-related. An example can be found in the [American Journal of Epidemiology](http://aje.oxfordjournals.org/content/176/11/1051.abstract) where this approach was used to investigate risk factors for child diarrhoea. A special issue of [Preventive Veterinary Medicine](http://www.sciencedirect.com/science/journal/01675877/110/1) on graphical modelling features a number of articles which use abn for fitting additive Bayesian network models to epidemiological data. An introduction to this methodology can also be found in [Emerging Themes in Epidemiology](http://www.ete-online.com/content/10/1/4).

This site provides some [cookbook](#Quickstart) type examples of how to perform Bayesian network **structure discovery** analyses with observational data. The particular type of Bayesian network models considered here are **additive Bayesian networks**. These are rather different, mathematically speaking, from the standard form of Bayesian network models (for binary or categorical data) presented in the academic literature, which typically use an analytically elegant, but arguably interpretationally opaque, contingency table parameterization. An additive Bayesian network model is simply a **multidimensional regression model**, e.g. directly analogous to generalised linear modelling but with all variables potentially dependent. All examples presented use an extension library for [R](http://www.r-project.org/) called [abn](https://CRAN.R-project.org/package=abn).

If you have any problems or questions about using the abn library or generally about Bayesian network modelling then please drop me an email marta.pittavino@unige.ch. Further contact details: University of Zurich, Applied Statistics Group and abn R package.

*Website and R package’s contributors:*
*Gilles Kratzer, Marta Pittavino, Fraser Lewis and Reinhard Furrer*

# Installation
# Quickstart
# Literature
# Case studies
# Quality assurance


# Introduction

Bayesian network modelling is a data analysis technique which is ideally suited to messy, complex data. This methodology is rather distinct from other forms of statistical modelling in that its focus is on **structure discovery** – determining an optimal graphical model which describes the inter-relationships in the underlying processes which generated the study data. It is, by construction, a **multivariate** technique and can used for one or many dependent variables. The key point of note here is that such graphical models are derived empirically from observed data, as opposed to, for example, relying only on subjective expert opinion to determine how variables of interest are inter-related. An example can be found in the [American Journal of Epidemiology](http://aje.oxfordjournals.org/content/176/11/1051.abstract) where this approach was used to investigate risk factors for child diarrhoea. A special issue of [Preventive Veterinary Medicine](http://www.sciencedirect.com/science/journal/01675877/110/1) on graphical modelling features a number of articles which use abn for fitting additive Bayesian network models to epidemiological data. An introduction to this methodology can also be found in [Emerging Themes in Epidemiology](http://www.ete-online.com/content/10/1/4).

This site provides some [cookbook](#Quickstart) type examples of how to perform Bayesian network **structure discovery** analyses with observational data. The particular type of Bayesian network models considered here are **additive Bayesian networks**. These are rather different, mathematically speaking, from the standard form of Bayesian network models (for binary or categorical data) presented in the academic literature, which typically use an analytically elegant, but arguably interpretationally opaque, contingency table parameterization. An additive Bayesian network model is simply a **multidimensional regression model**, e.g. directly analogous to generalised linear modelling but with all variables potentially dependent. All examples presented use an extension library for [R](http://www.r-project.org/) called [abn](https://CRAN.R-project.org/package=abn).

If you have any problems or questions about using the abn library or generally about Bayesian network modelling then please drop me an email marta.pittavino@unige.ch. Further contact details: University of Zurich, Applied Statistics Group and abn R package.

*Website and R package’s contributors:*

*[Gilles Kratzer](https://gilleskratzer.netlify.com/), Marta Pittavino, Fraser Lewis and [Reinhard Furrer](https://user.math.uzh.ch/furrer/)*

# Installation

abn R package can easily be installed from [CRAN](https://CRAN.R-project.org/package=abn) using:

```{r}
install.packages("abn")
```

However further [libraries](getting_started.md) could be necessary to best profit from the abn features.

# Quickstart

The following [examples](quickstart_examples.md) provide simple illustrations of how to perform data analyses using additive Bayesian networks with abn ( [installation instructions](getting_started.md)). The data sets used here are provided with abn. Many more examples are given at the end of the relevant manual pages in R, e.g. see ?fitabn, ?buildscorecache, ?mostprobable, ?search.hillclimber. More realistic examples are given in case studies.

# Literature

## General note
One general point of note is that typical BN models involving binary nodes, arguably the most commonly used type of BN, use a contingency table rather than additive parameter formulation. This facilities mathematical elegance and means that key metrics like model goodness of fit and marginal posterior parameters can be estimated analytically (e.g. from a formula) rather than numerically (an approximation). The downside being that this parameterisation is likely far from parsimonious, and the interpretation of the model parameters is less clear than in more usual GLM type models (which are common across all areas of science). This is, while practically important, a fairly low level technical distinction as the key aspect of BN modelling is that this is a form of graphical modelling – that is a model of the joint probability distribution of the data. It is this joint – multidimensional – aspect which makes this methodology so attractive for analyses of complex data and what discriminates it from the more standard regression techniques, e.g. glm’s, glmm’s etc, which are only one dimensional in that the covariates are all assumed independent. The latter is entirely reasonable in a classical experimental design scenario, but completely unrealistic for many observational studies in medicine, ecology and biology.

### Key technical/theoretical articles

- Koivisto et al. (2004): [Exact Bayesian structure discovery in Bayesian networks](https://static.aminer.org/pdf/PDF/000/984/996/exact_bayesian_structure_discovery_in_bayesian_networks.pdf)
- Friedman et al. (2003): [Being Bayesian about network structure. A Bayesian approach to structure discovery in Bayesian networks](http://web.cs.iastate.edu/~jtian/cs673/cs673_spring05/references/Friedman-Koller-2003.pdf)
- Friedman et al. (1999) [Data analysis with Bayesian networks: A bootstrap approach](http://scholar.google.com/scholar_url?hl=en&q=http://w3.cs.huji.ac.il/~nir/Papers/FGW2.pdf&sa=X&scisig=AAGBfm3-UgXALoAdzzXG_hPQAzhuMvYaiQ&oi=scholarr)
- Heckerman et al. (1995): [Learning Bayesian Networks – The Combination of Knowledge And Statistical-Data](http://maxchickering.com/publications/ml95.pdf)

### Application/case study articles

# Case studies

# Ressources



# Quality assurance


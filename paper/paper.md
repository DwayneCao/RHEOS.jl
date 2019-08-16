---
title: 'RHEOS.jl -- A Julia package for Rheology data analysis.'
tags:
  - Rheology
  - Fractional Rheology
  - Viscoelasticity
  - Fractional Viscoelasticity
  - Biomechanics
  - Julia
authors:
  - name: Jonathan Louis Kaplan
    orcid: 0000-0002-2700-5229
    affiliation: 1
  - name: Alessandra Bonfanti
    affiliation: 1
  - name: Alexandre J Kabla
    orcid: 0000-0002-0280-3531
    affiliation: 1
affiliations:
  - name: Engineering Department, Cambridge University, UK
    index: 1
date: 12 August 2019
bibliography: paper.bib
---
# Summary
Rheology is the science of deformation and flow. It encompasses a broad range of experimental methodologies (such as macro-scale tensile testing and micro-scale indentation tests) and a correspondingly broad range of theoretical tools.

RHEOS (Rheology, Open-Source) is a software package that is designed to make the analysis of linear rheological data simpler, faster and more reproducible. RHEOS has a particular emphasis on rheological models containing fractional derivatives which have demonstrable utility for the modelling of biological materials [@bonfantiUnifiedRheologicalModel2019; @kaplanPectinMethylesterificationImplications2019] but have hitherto remained in relative obscurity -- possibly due to their mathematical and computational complexity. RHEOS is written in Julia [@bezansonJuliaFreshApproach2017], which greatly assists achievement of our aims as it provides excellent computational efficiency and approachable syntax. RHEOS is fully documented and has extensive testing coverage.

To our knowledge there is no other software package that offers RHEOS' broad selection of rheology analysis tools and extensive library of both traditional and fractional models.

RHEOS has already been used in one study [@bonfantiUnifiedRheologicalModel2019] and is currently being used in at least four other studies and a review that are in progress.

It should be noted that RHEOS is not an optimisation package. It builds on another optimisation package, NLopt [@johnsonNLoptNonlinearoptimizationPackage], by adding a large number of abstractions and functionality specific to the exploration of viscoelastic data.

# Statement of Need
A large majority of scientists and engineers who undertanke rheological experiments intend to computationally fit the data with one or several viscoelastic models.

When fitting regular linear viscoelastic models to data under the assumption of step loading, the process is straightforward as it reduces to a direct optimisation of a function which consists of a small number of exponential terms. Indeed, possibly due to the computational convenience of the above, many studies do assume that their loading is accurately described by a step function and a traditional viscoelastic model. However the validity of this approach is not always tenable. With regard to the step assumption, a number of studies have noted the importance of small time-scale behaviour when fitting viscoelastic models [@bonfantiUnifiedRheologicalModel2019; @dipaolaInfluenceInitialRamp2014; @oyenSphericalIndentationCreep2005]. Taking into account a complete arbitrary loading history requires computing the viscoelastic hereditary integral:

$$ \sigma(t) = \int_{0}^t G(t - \tau) \frac{d \epsilon(\tau)}{d \tau} d \tau $$

Depending on the model kernel *G* and the sample rate(s) of the data, computation is not always straightforward and there are several approaches that can be used. With regard to the choice of model, the utility of fractional viscoelastic models has been well documented [@bonfantiUnifiedRheologicalModel2019]. Furthermore, these fractional viscoelastic models are often valuable in modelling biological materials, which may be studied by highly interdisciplinary research groups where there is neither the time or expertise required to develop fractional viscoelastic modelling software.

Obtaining intuition for fractional viscoelastic theory can be difficult, and learning material is sparse: of popular rheology textbooks published in 1989 [@barnesIntroductionRheology1989; @findleyCreepRelaxationNonlinear1989], 2008 [@brinsonPolymerEngineeringScience2008], 2009 [@lakesViscoelasticMaterials2009] and 2013 [@wardMechanicalPropertiesSolid2013], fractional viscoelasticity is only mentioned briefly in one of them [@lakesViscoelasticMaterials2009].

Lastly, although research groups may have closed-source code for their specific rheology fitting application, and limited open-source options are avilable [@Bobrheology; @seifertPythonToolsAnalysis2019], there presently does not exist any comprehensive open-source rheology software which addresses the entire gamut of linear rheology data analysis needs. This state of affairs reduces scientific reproducibility and leads to many researchers spending significant amounts of time writing their own software unnecessarily.

# Implementation
## Features
RHEOS addresses the issues outlined in the Statement of Need in several ways.

As well as being able to fit and predict assuming step loading of stress or strain, RHEOS can handle arbitrary loading for non-singular and singular models, and for constant or variable sample rates.

RHEOS includes an extensive library of both traditional and fractional viscoelastic models. Although this library will satisfy most users, it is also straightforward to add their own models to RHEOS should they need to.

For intuition-building and model exploration, RHEOS includes signal generation features so that common loading patterns (e.g. step, ramp, stairs) can be applied to unfamiliar models.

As a convenience to the user, RHEOS also includes easy-to-use CSV importing and exporting functions, as well as a number of preprocessing functions for resampling and smoothing.

All of the above features are linked together in a seamless interface intended to be very approachable for less experienced programmers. The different paradigms of creep, relaxation and oscillatory testing are all accounted for, and models fitted against one type of data can be used to predict against a different type of data. (For instance, fitting against relaxation data and predicting the frequency response spectrum.)

## Demonstration
A common RHEOS workflow is illustrated by the following example in which experimental time-domain viscoelastic data is fitted to a Maxwell model. This model is then used to make a prediction of the behaviour so that its qualitative accuracy can be assessed. This workflow is shown schematically in Figure 1, and the prediction of the fitted model is plotted against the original data in Figure 2.

A brief description of this workflow is the following. A CSV is imported into a RHEOS `RheoTimeData` using its convenience function. This is then fitted to a `RheoModelClass`, which is the model struct used when the model's parameters are not fixed. This results in a fitted `RheoModel`, which is similar to a `RheoModelClass` except it has fixed parameters. In the prediction step, the fitted `RheoModel` is combined with partial data (as only stress or strain is required, not both) and fills in the missing data column, resulting in a complete data set.

![High level schematic of a fitting and prediction workflow from experimental data.](diagram_v3.png)

![Qualitative assessment of the fitted model.](predictfigure.png)

# Acknowledgements
JLK Would like thank the George and Lillian Schiff Foundation for the PhD funding which facilitated this project.

# References
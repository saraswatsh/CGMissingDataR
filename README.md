
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CGMissingDataR

<!-- badges: start -->

[![R-CMD-check](https://github.com/saraswatsh/CGMissingData/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/saraswatsh/CGMissingData/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/saraswatsh/CGMissingData/graph/badge.svg)](https://app.codecov.io/gh/saraswatsh/CGMissingData)
<!-- badges: end -->

CGMissingDataR is an R package wrapping the CGMissingData Python library
for evaluating model performance under feature missingness by:

- injecting missing values into feature columns at specified masking
  rates,
- imputing missing values using a Multiple Imputation by Chained
  Equations (MICE)-style iterative imputer, and
- training Random Forest and k-Nearest Neighbors regressors to report
  Mean ABsolute Percentage Error (MAPE) and R across missingness levels.

## Installation

R Prerequisites:

``` r
install.packages("reticulate")
```

Install the development version of CGMissingDataR from GitHub:

``` r
devtools::install_github("saraswatsh/CGMissingDataR")
```

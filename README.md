
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CGMissingDataR

<!-- badges: start -->

[![R-CMD-check](https://github.com/saraswatsh/CGMissingDataR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/saraswatsh/CGMissingDataR/actions/workflows/R-CMD-check.yaml)
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

Prior to installation, ensure that you have Python and the required
Python packages installed. When using CGMissingDataR, the package should
automatically set up a suitable Python environment via the `reticulate`
package and install the necessary dependencies.

R Prerequisites:

``` r
install.packages("reticulate")
```

Install the development version of CGMissingDataR from GitHub:

``` r
devtools::install_github("saraswatsh/CGMissingDataR")
```

## Vignette

A brief vignette illustrating the usage of CGMissingDataR can be found
[here](https://saraswatsh.github.io/CGMissingDataR/articles/How-To-Use-CGMissingDataR.html).

## Changelog

The changelog is available
[here](https://saraswatsh.github.io/CGMissingDataR/news/index.html).

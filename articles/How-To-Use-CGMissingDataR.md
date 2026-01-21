# How To Use CGMissingDataR

## CGMissingDataR

CGMissingDataR is an R package based on the CGMissingData Python library
for evaluating model performance under feature missingness by:

- injecting missing values into feature columns at specified masking
  rates,
- imputing missing values using a Multiple Imputation by Chained
  Equations (MICE)-style iterative imputer, and
- training Random Forest and k-Nearest Neighbors regressors to report
  Mean ABsolute Percentage Error (MAPE) and R across missingness levels.

### Installation

Before the installation, ensure that you have the following R packages
installed:

``` r
install.packages(c("FNN", "ranger", "mice"))
```

Install the development version of CGMissingDataR from GitHub:

``` r
devtools::install_github("saraswatsh/CGMissingDataR")
```

### Example

Below is a brief example illustrating the usage of CGMissingDataR.

``` r
library(CGMissingDataR)

# Load example dataset
data("CGMExampleData")
results <- run_missingness_benchmark(CGMExampleData, mask_rates = c(0.05, 0.10, 0.15, 0.20),target_col = "LBORRES", # Running the missingness benchmark
feature_cols = c("TimeDifferenceMinutes", "TimeSeries", "USUBJID")) 
#> Warning: Number of logged events: 1
#> Warning: Number of logged events: 1
#> Warning: Number of logged events: 1
#> Warning: Number of logged events: 1
print(results) # Displaying the results
#>   MaskRate         Model      MAPE        R2
#> 1       5% Random Forest  7.425061 0.7487709
#> 2       5%           kNN  7.812956 0.7314915
#> 3      10% Random Forest  8.471379 0.6660876
#> 4      10%           kNN  8.957239 0.6397430
#> 5      15% Random Forest  9.775851 0.5552681
#> 6      15%           kNN 10.107433 0.5384117
#> 7      20% Random Forest 10.560843 0.4939590
#> 8      20%           kNN 11.110390 0.4642746
```

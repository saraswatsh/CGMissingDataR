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
devtools::install_github("ZhangLabUKY/CGMissingDataR")
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
#> 1       5% Random Forest  7.497932 0.7418421
#> 2       5%           kNN  7.898898 0.7276014
#> 3      10% Random Forest  8.510749 0.6683246
#> 4      10%           kNN  9.143478 0.6315460
#> 5      15% Random Forest  9.758954 0.5598508
#> 6      15%           kNN 10.345550 0.5201831
#> 7      20% Random Forest 10.189505 0.5363248
#> 8      20%           kNN 10.772825 0.4916150
```

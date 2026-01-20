# How To Use CGMissingDataR

## CGMissingDataR

CGMissingDataR is an R package wrapping the CGMissingData Python library
for evaluating model performance under feature missingness by:

- injecting missing values into feature columns at specified masking
  rates,
- imputing missing values using a Multiple Imputation by Chained
  Equations (MICE)-style iterative imputer, and
- training Random Forest and k-Nearest Neighbors regressors to report
  Mean ABsolute Percentage Error (MAPE) and R across missingness levels.

### Installation

Before the installation, ensure that you have Python and the required
Python packages installed. You can use the `reticulate` package to
manage Python environments from R.

``` r
install.packages("reticulate")
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
tmp <- tempfile(fileext = ".csv") # Creating a temporary file to store the dataset
write.csv(CGMExampleData, tmp, row.names = FALSE) # Writing the example dataset to the temporary file
results <- run_missingness_benchmark(tmp, mask_rates = c(0.05, 0.10, 0.15, 0.20)) # Running the missingness benchmark
print(results) # Displaying the first few rows of the results
#>   MaskRate         Model     MAPE        R2
#> 1      10% Random Forest 7.967675 0.7271567
#> 2      10%           KNN 8.453916 0.6986401
#> 3      15% Random Forest 8.540646 0.6920470
#> 4      15%           KNN 9.048134 0.6627346
#> 5      20% Random Forest 9.244178 0.6450390
#> 6      20%           KNN 9.685732 0.6158767
#> 7       5% Random Forest 7.074092 0.8014757
#> 8       5%           KNN 7.579474 0.7785196
```

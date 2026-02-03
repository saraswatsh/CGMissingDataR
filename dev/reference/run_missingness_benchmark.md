# Run missingness benchmark

Benchmarks model performance under feature missingness. The function:

1.  Filters to complete cases for `target_col` and `feature_cols`
    (baseline complete data),

2.  Splits into training/validation,

3.  Masks feature values at each rate using Bernoulli (cell-wise)
    missingness,

4.  Imputes missing features using MICE on training data and applies the
    fitted imputation model to validation data via
    `mice::mice.mids(newdata = ...)` (reduces leakage),

5.  Trains Random Forest (`ranger`) and kNN regression
    ([`FNN::knn.reg`](https://rdrr.io/pkg/FNN/man/knn.reg.html)),

6.  Returns MAPE and R-squared for each model and mask rate.

Feature columns must be numeric (or coercible to numeric without
introducing new missing values). This mirrors workflows where features
are treated as numeric arrays.

## Usage

``` r
run_missingness_benchmark(
  data,
  target_col,
  feature_cols = NULL,
  mask_rates = c(0.05, 0.1, 0.2, 0.3),
  rf_n_estimators = 200,
  knn_k = 5,
  test_size = 0.2,
  seed = 42
)
```

## Arguments

- data:

  A data.frame (or object coercible to data.frame) containing the
  dataset.

- target_col:

  Single character string: name of the outcome column.

- feature_cols:

  Character vector of feature column names. If `NULL`, uses all columns
  except `target_col`.

- mask_rates:

  Numeric vector in (0, 1): proportion of feature entries to mask per
  rate.

- rf_n_estimators:

  Integer: number of trees for the random forest.

- knn_k:

  Integer: number of neighbors for kNN regression.

- test_size:

  Numeric in (0, 1): fraction of rows assigned to validation split.

- seed:

  Integer: seed for data split and model reproducibility.

## Value

A data.frame with columns `MaskRate`, `Model`, `MAPE`, and `R2`.

## Details

Validation imputation is performed using
`mice::mice.mids(newdata = ...)`, which generates imputations for new
data according to the model stored in the training `mids` object.

MAPE is computed using
[`Metrics::mape()`](https://rdrr.io/pkg/Metrics/man/mape.html) on
non-zero targets only to avoid instability when actual values are zero.

## Author

Shubh Saraswat, Hasin Shahed Shad, and Xiaohua Douglas Zhang

## Examples

``` r
data("CGMExampleData")
run_missingness_benchmark(
  CGMExampleData,
  target_col = "LBORRES",
  feature_cols = c("TimeDifferenceMinutes", "TimeSeries", "USUBJID"),
  mask_rates = c(0.05, 0.10),
  rf_n_estimators = 100,
  knn_k = 3
)
#> Warning: Number of logged events: 1
#> Warning: Number of logged events: 1
#>   MaskRate         Model     MAPE        R2
#> 1       5% Random Forest 7.519025 0.7402591
#> 2       5%           kNN 8.140677 0.7095650
#> 3      10% Random Forest 8.520641 0.6684686
#> 4      10%           kNN 9.417613 0.6036350
```

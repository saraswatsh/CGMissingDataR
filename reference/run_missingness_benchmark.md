# Missing Data Benchmark Runner

Loads a CSV, splits train/validation, masks feature values at various
rates, imputes via an Iterative Imputer (MICE-style), trains Random
Forest and kNN regressors, and returns MAPE and R2 per model and mask
rate.

This function is a thin R wrapper over the Python implementation shipped
in `inst/python/CGMissingData`.

## Usage

``` r
run_missingness_benchmark(
  data_path,
  target_col = "LBORRES",
  feature_cols = c("TimeSeries", "TimeDifferenceMinutes", "USUBJID"),
  mask_rates = c(0.05, 0.1, 0.2, 0.3, 0.4),
  test_size = 0.2,
  random_state = 42,
  imputer_random_state = 42,
  rf_n_estimators = 200,
  knn_k = 5
)
```

## Arguments

- data_path:

  Path to a CSV file.

- target_col:

  Name of the target column.

- feature_cols:

  Character vector of feature column names.

- mask_rates:

  Numeric vector of missingness rates (0-1).

- test_size:

  Validation split fraction.

- random_state:

  Random seed for train/val splitting and model seeding.

- imputer_random_state:

  Random seed for the iterative imputer.

- rf_n_estimators:

  Number of trees for the random forest.

- knn_k:

  Number of neighbors for kNN.

## Value

A data.frame with columns MaskRate, Model, MAPE, R2.

## Author

Shubh Saraswat, Hasin Shahed Shad, and Xiaohua Douglas Zhang

## Examples

``` r
data("CGMExampleData")
tmp <- tempfile(fileext = ".csv")
write.csv(CGMExampleData, tmp, row.names = FALSE)
if (requireNamespace("reticulate", quietly = TRUE) &&
    reticulate::py_available(initialize = FALSE) &&
    reticulate::py_module_available("numpy") &&
    reticulate::py_module_available("pandas") &&
    reticulate::py_module_available("sklearn")) {
  results <- run_missingness_benchmark(tmp, mask_rates = c(0.05, 0.10))
  head(results)
}
```

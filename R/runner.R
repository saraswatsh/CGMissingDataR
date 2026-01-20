#' @title Missing Data Benchmark Runner
#'
#' @description
#' Loads a CSV, splits train/validation, masks feature values at various rates,
#' imputes via an Iterative Imputer (MICE-style), trains Random Forest and kNN
#' regressors, and returns MAPE and R2 per model and mask rate.
#'
#' This function is a thin R wrapper over the Python implementation shipped in
#' `inst/python/CGMissingData`.
#'
#' @param data_path Path to a CSV file.
#' @param target_col Name of the target column.
#' @param feature_cols Character vector of feature column names.
#' @param mask_rates Numeric vector of missingness rates (0-1).
#' @param test_size Validation split fraction.
#' @param random_state Random seed for train/val splitting and model seeding.
#' @param imputer_random_state Random seed for the iterative imputer.
#' @param rf_n_estimators Number of trees for the random forest.
#' @param knn_k Number of neighbors for kNN.
#'
#' @author Shubh Saraswat, Hasin Shahed Shad, and Xiaohua Douglas Zhang
#'
#' @return A data.frame with columns MaskRate, Model, MAPE, R2.
#' @import reticulate
#' @examples
#' data("CGMExampleData")
#' tmp <- tempfile(fileext = ".csv")
#' write.csv(CGMExampleData, tmp, row.names = FALSE)
#' if (requireNamespace("reticulate", quietly = TRUE) &&
#'     reticulate::py_available(initialize = FALSE) &&
#'     reticulate::py_module_available("numpy") &&
#'     reticulate::py_module_available("pandas") &&
#'     reticulate::py_module_available("sklearn")) {
#'   results <- run_missingness_benchmark(tmp, mask_rates = c(0.05, 0.10))
#'   head(results)
#' }
#' @export
run_missingness_benchmark <- function(
  data_path,
  target_col = "LBORRES",
  feature_cols = c("TimeSeries", "TimeDifferenceMinutes", "USUBJID"),
  mask_rates = c(0.05, 0.10, 0.20, 0.30, 0.40),
  test_size = 0.20,
  random_state = 42,
  imputer_random_state = 42,
  rf_n_estimators = 200,
  knn_k = 5
) {
  if (!file.exists(data_path)) {
    stop("data_path does not exist: ", data_path)
  }
  if (!is.numeric(mask_rates) || any(mask_rates <= 0) || any(mask_rates >= 1)) {
    stop("mask_rates must be numeric values strictly between 0 and 1")
  }

  # Access module loaded in zzz.R
  if (
    !exists(
      ".cgmd_py",
      envir = asNamespace("CGMissingDataR"),
      inherits = FALSE
    ) ||
      is.null(get(".cgmd_py", envir = asNamespace("CGMissingDataR")))
  ) {
    stop("Python module was not initialized. Check reticulate configuration.")
  }
  mod <- get(".cgmd_py", envir = asNamespace("CGMissingDataR"))

  cfg <- mod$runner$BenchmarkConfig(
    test_size = test_size,
    random_state = as.integer(random_state),
    imputer_random_state = as.integer(imputer_random_state),
    rf_n_estimators = as.integer(rf_n_estimators),
    knn_k = as.integer(knn_k)
  )

  res <- mod$runner$run_missingness_benchmark(
    data_path = data_path,
    target_col = target_col,
    feature_cols = reticulate::r_to_py(feature_cols),
    mask_rates = reticulate::r_to_py(mask_rates),
    config = cfg
  )

  # Convert pandas.DataFrame -> R data.frame
  reticulate::py_to_r(res)
}

test_that("run_missingness_benchmark returns expected columns", {
  # Minimal synthetic data
  d <- data.frame(
    LBORRES = rnorm(200),
    TimeSeries = rnorm(200),
    TimeDifferenceMinutes = runif(200, 0, 10),
    USUBJID = rnorm(200)
  )
  out <- run_missingness_benchmark(
    d,
    mask_rates = c(0.05, 0.10),
    target_col = "LBORRES",
    feature_cols = c("TimeDifferenceMinutes", "TimeSeries", "USUBJID")
  )
  expect_true(all(c("MaskRate", "Model", "MAPE", "R2") %in% names(out)))
  expect_equal(nrow(out), 2 * 2) # 2 mask rates x 2 models
})

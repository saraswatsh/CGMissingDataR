test_that("run_missingness_benchmark returns expected columns", {
  skip_if_no_cgmd_python()
  skip_if_not_installed("reticulate")

  # Minimal synthetic CSV
  tmp <- tempfile(fileext = ".csv")
  d <- data.frame(
    LBORRES = rnorm(200),
    TimeSeries = rnorm(200),
    TimeDifferenceMinutes = runif(200, 0, 10),
    USUBJID = rnorm(200)
  )
  write.csv(d, tmp, row.names = FALSE)

  out <- run_missingness_benchmark(tmp, mask_rates = c(0.05, 0.10))
  expect_true(all(c("MaskRate", "Model", "MAPE", "R2") %in% names(out)))
  expect_equal(nrow(out), 2 * 2) # 2 mask rates x 2 models
})

#' Example dataset for CGMissingData
#'
#' A small synthetic dataset intended for examples and tests of
#' `run_missingness_benchmark()`.
#'
#' @format A data frame with 250 rows and 6 variables:
#' \describe{
#'   \item{LBORRES}{Laboratory Observed Result for Glucose (numeric).}
#'   \item{TimeSeries}{Numeric feature representing time series data.}
#'   \item{TimeDifferenceMinutes}{Time difference in minutes between measurements (numeric).}
#'   \item{USUBJID}{Numeric subject identifier.}
#'   \item{SiteID}{Site identifier (character).}
#'   \item{Visit}{Visit label (character).}
#' }
#' @examples
#' data("CGMExampleData")
"CGMExampleData"

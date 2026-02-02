# Example dataset for CGMissingData

A small synthetic dataset intended for examples and tests of
[`run_missingness_benchmark()`](https://zhanglabuky.github.io/CGMissingDataR/reference/run_missingness_benchmark.md).

## Usage

``` r
CGMExampleData
```

## Format

A data frame with 250 rows and 6 variables:

- LBORRES:

  Laboratory Observed Result for Glucose (numeric).

- TimeSeries:

  Numeric feature representing time series data.

- TimeDifferenceMinutes:

  Time difference in minutes between measurements (numeric).

- USUBJID:

  Numeric subject identifier.

- SiteID:

  Site identifier (character).

- Visit:

  Visit label (character).

## Examples

``` r
data("CGMExampleData")
```

# CGMissingData (R)

This is an R wrapper around the provided Python implementation.

## Install (development)

```r
# From a local checkout
install.packages("CGMissingData", repos = NULL, type = "source")
```

## Use

```r
library(CGMissingData)
res <- run_missingness_benchmark("Modified_Data_1P (1).csv")
print(res)
```

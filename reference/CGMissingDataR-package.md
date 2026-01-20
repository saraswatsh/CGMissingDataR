# CGMissingDataR: Missingness Benchmark (MICE Imputation, Random Forest, kNN)

Evaluates predictive performance under feature-level missingness in
repeated-measures continuous glucose monitoring-like data. The benchmark
injects missing values at user-specified rates, imputes incomplete
feature matrices using an iterative chained-equations approach inspired
by multivariate imputation by chained equations (MICE) (Melissa J. Azur,
Elizabeth A. Stuart, Constantine Frangakis and Philip J. Leaf (2011)
[doi:10.1002/mpr.329](https://doi.org/10.1002/mpr.329) ), fits Random
Forest regression models (Leo Breiman (2001)
[doi:10.1023/A:1010933404324](https://doi.org/10.1023/A%3A1010933404324)
) and k-nearest-neighbor regression models (Zhongheng Zhang (2016)
[doi:10.21037/atm.2016.03.37](https://doi.org/10.21037/atm.2016.03.37)
), and reports mean absolute percentage error (MAPE) and R-squared (R2)
across missingness rates.

## See also

Useful links:

- <https://github.com/saraswatsh/CGMissingDataR>

- <https://saraswatsh.github.io/CGMissingDataR/>

- Report bugs at <https://github.com/saraswatsh/CGMissingDataR/issues>

## Author

**Maintainer**: Shubh Saraswat <shubh.saraswat00@gmail.com>
([ORCID](https://orcid.org/0009-0009-2359-1484)) \[copyright holder\]

Authors:

- Hasin Shahed Shad <hasin.shad@uky.edu>

- Xiaohua Douglas Zhang <douglas.zhang@uky.edu>
  ([ORCID](https://orcid.org/0000-0002-2486-7931))

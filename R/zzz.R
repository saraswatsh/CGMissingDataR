#' @import reticulate
NULL

.cgmd_py <- NULL

#' @keywords internal
.onLoad <- function(libname, pkgname) {
  # Declare (and optionally provision) Python dependencies.
  # Users who manage their own Python can ignore this, but it helps "just work".
  reticulate::py_require(c("numpy", "pandas", "scikit-learn"))

  # Delay-load the module so package load does not fail on systems without Python deps.
  pkg_python <- system.file("python", package = pkgname)
  .cgmd_py <<- reticulate::import_from_path("CGMissingData", path = pkg_python, delay_load = TRUE)
}

skip_if_no_cgmd_python <- function() {
  skip_if_not_installed("reticulate")

  if (!reticulate::py_available(initialize = FALSE)) {
    skip("Python not available for reticulate")
  }

  needed <- c("numpy", "pandas", "sklearn")
  missing <- needed[
    !vapply(needed, reticulate::py_module_available, logical(1))
  ]
  if (length(missing)) {
    skip(paste("Missing Python modules:", paste(missing, collapse = ", ")))
  }
}

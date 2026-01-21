#' @title Run missingness benchmark
#'
#' @description
#' Benchmarks model performance under feature missingness. The function:
#' \enumerate{
#'   \item Filters to complete cases for \code{target_col} and \code{feature_cols} (baseline complete data),
#'   \item Splits into training/validation,
#'   \item Masks feature values at each rate using Bernoulli (cell-wise) missingness,
#'   \item Imputes missing features using MICE on training data and applies the fitted imputation model to
#'         validation data via \code{mice::mice.mids(newdata = ...)} (reduces leakage),
#'   \item Trains Random Forest (\code{ranger}) and kNN regression (\code{FNN::knn.reg}),
#'   \item Returns MAPE and R-squared for each model and mask rate.
#' }
#'
#' Feature columns must be numeric (or coercible to numeric without introducing new missing values).
#' This mirrors workflows where features are treated as numeric arrays.
#'
#' @param data A data.frame (or object coercible to data.frame) containing the dataset.
#' @param target_col Single character string: name of the outcome column.
#' @param feature_cols Character vector of feature column names. If \code{NULL},
#'   uses all columns except \code{target_col}.
#' @param mask_rates Numeric vector in (0, 1): proportion of feature entries to mask per rate.
#' @param rf_n_estimators Integer: number of trees for the random forest.
#' @param knn_k Integer: number of neighbors for kNN regression.
#' @param test_size Numeric in (0, 1): fraction of rows assigned to validation split.
#' @param seed Integer: seed for data split and model reproducibility.
#'
#' @return A data.frame with columns \code{MaskRate}, \code{Model}, \code{MAPE}, and \code{R2}.
#'
#' @details
#' Validation imputation is performed using \code{mice::mice.mids(newdata = ...)}, which generates imputations
#' for new data according to the model stored in the training \code{mids} object.
#'
#' MAPE is computed using \code{Metrics::mape()} on non-zero targets only to avoid instability when actual values are zero.
#'
#' @author Shubh Saraswat, Hasin Shahed Shad, and Xiaohua Douglas Zhang
#'
#' @importFrom FNN knn.reg
#' @importFrom ranger ranger
#' @importFrom mice mice complete mice.mids
#' @importFrom stats predict
#' @importFrom Metrics mape
#'
#' @examples
#' data("CGMExampleData")
#' run_missingness_benchmark(
#'   CGMExampleData,
#'   target_col = "LBORRES",
#'   feature_cols = c("TimeDifferenceMinutes", "TimeSeries", "USUBJID"),
#'   mask_rates = c(0.05, 0.10)
#' )
#'
#' @export
run_missingness_benchmark <- function(
  data,
  target_col,
  feature_cols = NULL,
  mask_rates = c(0.05, 0.10, 0.20, 0.30),
  rf_n_estimators = 200,
  knn_k = 5,
  test_size = 0.2,
  seed = 42
) {
  set.seed(seed)
  df <- as.data.frame(data)

  coerce_numeric_strict <- function(x, nm) {
    if (is.numeric(x) || is.integer(x)) {
      return(as.double(x))
    }
    if (is.factor(x)) {
      x <- as.character(x)
    }

    if (is.character(x)) {
      num <- suppressWarnings(as.numeric(x))
      # coercion "failed" where original values were non-missing and non-empty
      bad <- is.na(num) & !is.na(x) & nzchar(x)
      if (any(bad)) {
        stop(
          "Column '",
          nm,
          "' contains non-numeric values"
        )
      }
      return(num)
    }

    stop("Column '", nm, "' has unsupported type for numeric coercion.")
  }
  # 1. Setup Feature Columns
  if (is.null(feature_cols)) {
    feature_cols <- setdiff(names(df), target_col)
  }

  needed <- c(target_col, feature_cols)

  missing_cols <- setdiff(needed, names(df))
  if (length(missing_cols) > 0) {
    stop("Missing required columns: ", paste(missing_cols, collapse = ", "))
  }

  for (nm in needed) {
    df[[nm]] <- coerce_numeric_strict(df[[nm]], nm)
  }

  # 2. Baseline Cleaning (Drop rows where Target OR Features are already NA)
  req_cols <- c(target_col, feature_cols)
  df <- df[stats::complete.cases(df[, req_cols, drop = FALSE]), , drop = FALSE]

  # 3. Split Train/Val
  n <- nrow(df)
  train_idx <- sample(seq_len(n), size = floor((1 - test_size) * n))

  X_train_clean <- df[train_idx, feature_cols, drop = FALSE]
  y_train <- df[train_idx, target_col]
  X_val_clean <- df[-train_idx, feature_cols, drop = FALSE]
  y_val <- df[-train_idx, target_col]

  results_list <- list()

  # --- HELPER: sklearn-like StandardScaler (population SD, ddof = 0) ---
  fit_scaler <- function(mat) {
    mat <- as.matrix(mat)
    mu <- colMeans(mat, na.rm = TRUE)

    centered <- sweep(mat, 2, mu, "-")
    var_pop <- colMeans(centered^2, na.rm = TRUE)
    sd_pop <- sqrt(var_pop)
    sd_pop[sd_pop == 0 | !is.finite(sd_pop)] <- 1

    list(mean = mu, scale = sd_pop)
  }

  transform_scaler <- function(mat, scaler) {
    mat <- as.matrix(mat)
    out <- sweep(mat, 2, scaler$mean, "-")
    out <- sweep(out, 2, scaler$scale, "/")
    out[!is.finite(out)] <- 0
    out
  }

  for (rate in mask_rates) {
    set.seed(seed + as.integer(rate * 100))
    # --- Masking Function ---
    mask_matrix <- function(dat, r) {
      d_out <- dat
      m_mat <- matrix(
        stats::runif(nrow(d_out) * ncol(d_out)) < r,
        nrow = nrow(d_out),
        ncol = ncol(d_out)
      )
      d_out[m_mat] <- NA_real_
      d_out
    }
    X_train_masked <- mask_matrix(X_train_clean, rate)
    X_val_masked <- mask_matrix(X_val_clean, rate)

    # --- Imputation (MICE) ---
    imp_train <- mice::mice(
      X_train_masked,
      m = 1,
      maxit = 10,
      method = "norm",
      ridge = 1e-5,
      printFlag = FALSE,
      seed = seed
    )

    X_train_imp <- mice::complete(imp_train, 1)

    imp_val <- mice::mice.mids(
      imp_train,
      newdata = X_val_masked,
      maxit = 1,
      printFlag = FALSE
    )
    X_val_imp <- mice::complete(imp_val, 1)

    # --- Model 1: Random Forest ---
    rf_data <- data.frame(y_target = y_train, X_train_imp)

    # mtry = number of features. Matches sklearn max_features=1.0
    rf_model <- ranger::ranger(
      y_target ~ .,
      data = rf_data,
      num.trees = rf_n_estimators,
      mtry = length(feature_cols),
      min.node.size = 1,
      replace = TRUE,
      sample.fraction = 1,
      seed = seed,
      num.threads = 1
    )

    rf_pred <- stats::predict(rf_model, data = X_val_imp)$predictions

    # --- Model 2: KNN ---
    # sklearn-like scaling (population SD; fit on train, apply to val)
    scaler <- fit_scaler(X_train_imp)
    X_train_scaled <- transform_scaler(X_train_imp, scaler)
    X_val_scaled <- transform_scaler(X_val_imp, scaler)

    knn_pred <- FNN::knn.reg(
      train = X_train_scaled,
      test = X_val_scaled,
      y = y_train,
      k = knn_k
    )$pred

    # --- Metrics ---
    calc_mape <- function(truth, pred) {
      mask <- truth != 0
      if (!any(mask)) {
        return(NA)
      }
      Metrics::mape(truth[mask], pred[mask]) * 100
    }

    calc_r2 <- function(truth, pred) {
      1 - sum((truth - pred)^2) / sum((truth - mean(truth))^2)
    }

    results_list[[length(results_list) + 1]] <- data.frame(
      MaskRate = rate,
      Model = "Random Forest",
      MAPE = calc_mape(y_val, rf_pred),
      R2 = calc_r2(y_val, rf_pred)
    )

    results_list[[length(results_list) + 1]] <- data.frame(
      MaskRate = rate,
      Model = "kNN",
      MAPE = calc_mape(y_val, knn_pred),
      R2 = calc_r2(y_val, knn_pred)
    )
  }

  final_df <- do.call(rbind, results_list)
  final_df <- final_df[order(final_df$MaskRate, final_df$MAPE), ]
  final_df$MaskRate <- paste0(as.integer(final_df$MaskRate * 100), "%")
  rownames(final_df) <- NULL
  return(final_df)
}

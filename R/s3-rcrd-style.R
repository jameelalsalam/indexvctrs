
#' Index Vector
#'
#' @param df data frame with indices and `value` column
#' @param idx character vector of index columns
#'
new_idx_vctr <- function(df, idx) {
  stopifnot(is.data.frame(df))
  stopifnot(is.character(idx))
  stopifnot(all(idx %in% names(df))) #idx must be in names(df)
  stopifnot("value" %in% names(df)) #must have 1 and only 1 value

  idxs <- df[idx]
  value <- df[["value"]]

  vctrs::new_rcrd(
    fields = list(
      idx = idxs,
      value = value
    ),

    idx = idx,
    class = "idx_vctr"
  )
}

# normalization:
# 1) arrange in idx order
# 2) columns in idx order

validate_idx_df <- function(x) {
  if (length( setdiff( attr(x, "idx"), names(x) )) != 0) {
    stop("Index values not in data", .call = FALSE)}

  # if (! tblrelations::pk_ish(as_tibble()))

  if (! "value" %in% names(x)) stop("Data must have a `value` column representing the index vector values.")

  invisible(x)
}

#' Get Indices
#'
#' @param x index vector
#'
get_idxs <- function(x) {

}

get_val <- function(x) {

}


# idx_df <- function(x, idx, value="value") {
#
#   #coercing function will rename a column in the data to `value` as specified to represent the values.
#
# }


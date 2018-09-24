
new_idx_df <- function(df, idx) {
  stopifnot(is.data.frame(df))
  stopifnot(is.character(idx)) #idx must be in names(df)
  #idx can be named or not

  structure(
    df,
    idx = idx,
    class = c("idx_df", "data.frame")
  )
}


validate_idx_df <- function(x) {
  if (length( setdiff( attr(x, "idx"), names(x) )) != 0) {
    stop("Index values not in data", .call = FALSE)}

  if (! tblrelations::pk_ish(as_data_frame()))

  if (! "value" %in% names(x)) stop("Data must have a `value` column representing the index vector values.")

  invisible(x)
}


# idx_df <- function(x, idx, value="value") {
#
#   #coercing function will rename a column in the data to `value` as specified to represent the values.
#
# }


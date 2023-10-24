
#' Get values of an idx_tbl for specific index values
#'
#' @param x an idx_tbl
#' @param idx an index that can be used with x
#'
#' @export
value_at_idx <- function(x, idx) {

  # TODO: x must be idx_tbl
  # TODO: idx must be an index in compliance with x

  res <- value(along_index(x, idx = idx))
  res
}

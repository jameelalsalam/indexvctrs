
#' Get values of an idx_tbl for specific index values
#'
#' @export
value_at_idx <- function(x, idx) {

  # TODO: x must be idx_tbl
  # TODO: idx must be an index in compliance with x

  res <- value(along_index(x, idx = idx))
  res
}

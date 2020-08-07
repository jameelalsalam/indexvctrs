
# For now, just aiming to support 1-d numeric indexing, for use in dplyr

#' @export
`[.idx_tbl` <- function(x, i, j, ... , drop = FALSE) {

  data <- NextMethod()

  idx_cols_new <- intersect(names(data), idx_cols(x))

  if("value" %in% names(data)) {
    new_idx_tibble(data, idx_cols = idx_cols_new)
  } else {
    attr(data, "idx_cols") <- NULL
  }
}

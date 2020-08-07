
# See: https://dplyr.tidyverse.org/reference/dplyr_extending.html
# idx_tbl has a scalar attribute which depends on columns (e.g., idx_cols must exist and the value column must exist)
# The dplyr-extending article recommends implementation of 1-d numeric indexing and a dplyr_reconstruct method.


# For now, just aiming to support 1-d numeric indexing, for use in dplyr

#' @export
`[.idx_tbl` <- function(x, i, j, ... , drop = FALSE) {

  data <- NextMethod()

  idx_cols_new <- intersect(names(data), idx_cols(x))
  has_value_col <- "value" %in% names(data)

  if(has_value_col) {
    new_idx_tibble(data, idx_cols = idx_cols_new)
  } else {
    attr(data, "idx_cols") <- NULL
    data
  }
}

#' @export
#' @method dplyr_reconstruct idx_tbl
dplyr_reconstruct.idx_tbl <- function(data, template) {

  idx_cols_new <- intersect(names(data), idx_cols(template))
  has_value_col <- "value" %in% names(data)

  if(has_value_col) {
    new_idx_tibble(data, idx_cols = idx_cols_new)
  } else {
    attr(data, "idx_cols") <- NULL
    class(data) <- setdiff(class(data), "idx_tbl")
    data
  }
}

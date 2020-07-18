# index-ops.R

#' Combine indices for coalesce
#'
#' @examples
#' t1 <- new_idx_tibble(tibble(year = 2005, value = 1), idx = "year")
#' t2 <- new_idx_tibble(tibble(year = 2010, value = 2), idx = "year")
#' full_common_index(index(t1), index(t2))
full_common_index <- function(idx_x, idx_y) {

  if(!is.null(idx_x) && !is.null(idx_y)) {
    common_cols <- intersect(names(idx_x), names(idx_y))
    dplyr::full_join(idx_x, idx_y, by = common_cols)
  } else {
    idx_x %||% idx_y
  }
}

#' Coalesce indexvectors by index
#'
#' @export
#' @import purrr
#' @examples
#' t1 <- new_idx_tibble(tibble(year = 2005, value = 1), idx = "year")
#' t2 <- new_idx_tibble(tibble(year = 2010, value = 2), idx = "year")
#' t3 <- new_idx_tibble(tibble(year = c(2010, 2011), value = c(1.1, 1.2)), idx = "year")
#' coalesce_by_idx(t1, t2)
#' coalesce_by_idx(t1, t2, t3)
coalesce_by_idx <- function(...) {
  vs <- list(...)
  idx_vs <- map(vs, index)

  common_idx <- Reduce(full_common_index, idx_vs)

  idx_vs_common <- purrr::map(vs, ~along_index(.x, common_idx))
  vals <- map(idx_vs_common, value)
  res <- dplyr::coalesce(!!!vals)
  new_idx_tibble(bind_cols(common_idx, tibble(value = res)), idx = names(common_idx))
}

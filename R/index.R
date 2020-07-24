#' Retrieve index columns of an idx_tbl
#'
#' @param x an idx_tbl
#' @export
idx_cols <- function(x) {
  stopifnot(inherits(x, "idx_tbl"))
  attr(x, "idx_cols")
}

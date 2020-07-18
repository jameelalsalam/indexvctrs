
#' Tibble-style index vector
#'
#' @param tbl on which to base it
#' @param idx character vector designating idx columns
#'
#' @import tibble
#' @export
new_idx_tibble <- function(tbl, idx) {
  stopifnot(is_tibble(tbl))
  stopifnot(is.character(idx))
  stopifnot(all(idx %in% names(tbl))) #idx must be in names(df)
  stopifnot("value" %in% names(tbl)) #must have 1 and only 1 value

  tibble::new_tibble(
    tbl,
    idx = idx,
    nrow = nrow(tbl),
    class = "idx_tbl"
  )
}

#' @export
value <- function(x, ...) {
  UseMethod("value", x)
}

#' @export
value.idx_tbl <- function(x, ...) {
  dplyr::pull(x, "value")
}

index <- function(x, ...) {
  UseMethod("index", x)
}

index.idx_tbl <- function(x, ...) {
  dplyr::select(x, attr(x, "idx"))
}

index.double <- function(x, ...) {
  NULL
}

inner_common_index <- function(idx_x, idx_y) {

  if(!is.null(idx_x) && !is.null(idx_y)) {
    common_cols <- intersect(names(idx_x), names(idx_y))
    dplyr::inner_join(idx_x, idx_y, by = common_cols)
  } else {
    idx_x %||% idx_y
  }
}

along_index <- function(x, idx, ...) {
  UseMethod("along_index", x)
}

along_index.idx_tbl <- function(x, idx, ...) {
  common_by <- intersect(names(idx), attr(x, "idx"))

  left_join(idx, x, by = common_by)
}

along_index.double <- function(x, idx, ...) {
  if(length(x) == nrow(idx) || length(x) == 1) {
    new_idx_tibble(
      mutate(idx, value = x),
      idx = names(idx)
      )
  } else {
    stop("Incompatible lengths of x and idx in along_index.double")
  }
}

#' @import dplyr
#' @import rlang
#' @method Ops idx_tbl
#' @export
Ops.idx_tbl <- function(x, y) {

  idx_x <- index(x)
  idx_y <- index(y)

  idx_common <- inner_common_index(idx_x, idx_y)

  x_along <- along_index(x, idx_common)
  y_along <- along_index(y, idx_common)

  res <- exec(.Generic, value(x_along), value(y_along))

  along_index(res, idx_common)
}

#' @method Summary idx_tbl
#' @export
Summary.idx_tbl <- function(x, ...) {

  res <- exec(.Generic, value(x))
  res
}

#' @method mean idx_tbl
#' @export
mean.idx_tbl <- function(x, ...) {
  mean(value(x))
}

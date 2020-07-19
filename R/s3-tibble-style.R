
#' Tibble-style index vector
#'
#' @param x tibble data
#' @param idx_cols character vector designating idx columns
#'
#' @import tibble
#' @export
new_idx_tibble <- function(x, idx_cols) {
  stopifnot(is_tibble(x))
  stopifnot(is.character(idx_cols))

  tibble::new_tibble(
    x,
    idx_cols = idx_cols,
    nrow = nrow(x),
    class = "idx_tbl"
  )
}

#' Tibble-style index vector
#'
#' @param x data coercible to tbl_df
#' @param index_cols character vector, name of index columns
#' @param value_col length-1 character vector, name of value column, will be renamed as `value`
#' @import dplyr
#' @export
idx_tibble <- function(x,
                       idx_cols = setdiff(names(tbl), "value"),
                       value_col = "value") {

  tbl <- as_tibble(x)
  stopifnot(all(idx_cols %in% names(tbl)))
  stopifnot(value_col %in% names(tbl)) #must have 1 and only 1 value

  tbl_res <- as_tibble(tbl) %>%
    select(idx_cols, value_col) %>%
    rename(value = !!value_col) %>%
    arrange_at(idx_cols)

  new_idx_tibble(tbl_res, idx_cols = idx_cols)
}


#' @export
value <- function(x, ...) {
  UseMethod("value", x)
}

#' @export
value.idx_tbl <- function(x, ...) {
  dplyr::pull(x, "value")
}

#' @export
index <- function(x, ...) {
  UseMethod("index", x)
}

#' @method index idx_tbl
#' @export
index.idx_tbl <- function(x, ...) {
  dplyr::select(x, attr(x, "idx"))
}

#' @method index double
#' @export
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

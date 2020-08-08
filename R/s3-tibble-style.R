
#' Tibble-style index vector
#'
#' @param x tibble data
#' @param idx_cols character vector designating idx columns
#'
#' @export
new_idx_tibble <- function(x, idx_cols) {
  stopifnot(inherits(x, "data.frame"))
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
#' @param idx_cols character vector, name of index columns
#' @param value_col length-1 character vector, name of value column, defaults as "value" if present, will be renamed as `value`
#' @import dplyr
#' @export
idx_tibble <- function(x,
                       idx_cols = NULL,
                       value_col = NULL) {

  tbl <- as_tibble(x)

  stopifnot(all(idx_cols %in% names(tbl)))

  # value_col defaults:
  # 1) if specified, use that (if idx_cols is unspecified, all others become idx_cols)
  # 2) if "value" is present, use that
  # 3) if all but one column is specified as an index, use that
  # 4) else use the last column (assuming its not an idx_col)
  # 5) error

  len_names <- length(names(tbl))
  last_col  <- names(tbl)[[len_names]]
  non_idx_cols <- setdiff(names(tbl), idx_cols)

  if(is.null(value_col)) {
    if("value" %in% names(tbl)) {
      value_col <- "value"

    } else if(length(non_idx_cols) == 1) {
        value_col <- non_idx_cols

      } else if(!last_col %in% idx_cols) {
        value_col <- last_col} else {
          stop("Cannot determine default `value_col`")
        }
  }

  # idx_cols defaults to non-value columns:
  if(is.null(idx_cols)) idx_cols <- setdiff(names(tbl), value_col)


  stopifnot(value_col %in% names(tbl)) #must have 1 and only 1 value

  tbl_res <- as_tibble(tbl) %>%
    select(idx_cols, value_col) %>%
    rename(value = !!value_col) %>%
    arrange_at(idx_cols)

  new_idx_tibble(tbl_res, idx_cols = idx_cols)
}

#' The values from an indexvctr
#'
#' @param x idx_tbl object
#' @param ... dots unused
#'
#' @export
value <- function(x, ...) {
  UseMethod("value", x)
}

#' @export
value.idx_tbl <- function(x, ...) {
  dplyr::pull(x, "value")
}

idx_cols <- function(x) {
  attr(x, "idx_cols")
}

#' Index of an object
#'
#' @param x a idx_tbl, double, or other object compatible with indexvctrs ops
#' @param ... unused
#'
#' @export
index <- function(x, ...) {
  UseMethod("index", x)
}

#' @method index idx_tbl
#' @export
index.idx_tbl <- function(x, ...) {
  dplyr::select(x, idx_cols(x)) %>%
    dplyr::distinct(across()) %>%
    as_tibble()
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

#' Make or reshape an idx_tbl by arranging values along an index
#'
#' @param x values (or idx_tbl)
#' @param idx index data, e.g., unique combinations of columns that will correspond to idx_cols
#'
#' @keywords internal
along_index <- function(x, idx, ...) {
  UseMethod("along_index", x)
}

along_index.idx_tbl <- function(x, idx, ...) {
  common_by <- intersect(names(idx), idx_cols(x))

  dat <- left_join(idx, x, by = common_by)
  new_idx_tibble(dat, idx_cols = names(idx))
}

along_index.double <- function(x, idx, ...) {
  if(length(x) == nrow(idx) || length(x) == 1) {
    new_idx_tibble(
      mutate(idx, value = x),
      idx_cols = names(idx)
      )
  } else {
    stop("Incompatible lengths of x and idx in along_index.double")
  }
}

#' @method along_index units
along_index.units <- function(x, idx, ...) {
  if(length(x) == nrow(idx) || length(x) == 1) {
    new_idx_tibble(
      mutate(idx, value = x),
      idx_cols = names(idx)
    )
  } else {
    stop("Incompatible lengths of x and idx in along_index.units")
  }
}


#' @import dplyr
#' @import rlang
#' @method Ops idx_tbl
#' @export
Ops.idx_tbl <- function(e1, e2) {

  x <- e1
  y <- e2

  idx_x <- index(x)
  idx_y <- index(y)

  idx_common <- full_common_index(idx_x, idx_y)

  x_along <- along_index(x, idx_common)
  y_along <- along_index(y, idx_common)

  res <- exec(.Generic, value(x_along), value(y_along))

  along_index(res, idx_common)
}

#' @method Summary idx_tbl
#' @export
Summary.idx_tbl <- function(x, ...) {

  res <- exec(.Generic, value(x))
  idx_tibble(res)
}

#' @method mean idx_tbl
#' @export
mean.idx_tbl <- function(x, ...) {
  idx_tibble(mean(value(x)))
}

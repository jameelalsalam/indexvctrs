
#' Slice idx_tbl by index values
#'
#' Analagous to a left-join of the input against a differently shaped index.
#'
#' @param x idx_tbl indexvector
#' @param ... index values to slice. If unnamed, refer to idx_cols of x in order. If named they all must be named, and refer to idx_cols by name.
#' @param .keep_all unused, but perhaps to be used in future.
#'
#' @return idx_tbl with the same axes as input.
#'
#' @importFrom tidyr expand_grid
#' @importFrom stats setNames
#' @export
#'
#' @examples
#' pop <- idx_tibble(tidyr::population, idx_cols = c("country", "year"))
#' idx_slice(pop, "Armenia")
#' idx_slice(pop, year=2000)
#' pop_grow <- pop / idx_slice(pop, year=2000)
idx_slice <- function(x, ..., .keep_all = FALSE) {

  stopifnot(inherits(x, "idx_tbl"))

  # if any dots are named, all must be named
  # number of dots must be <= number of indexes
  # type of dots must be coercible to corresponding indexes

 dots <- list2(...)

 all_unnamed <- is.null(names(dots))
 unnamed_pos <- names(dots) == ""
 unnamed_dots <- if(all_unnamed) dots else dots[unnamed_pos]
 named_dots <- if(all_unnamed) dots[NULL] else dots[!unnamed_pos]

 if(! xor(length(named_dots) > 0, length(unnamed_dots) > 0)) stop("Index slicing must use *either* named or unnamed args.")

 if(length(unnamed_dots) > 0) {
   index_names <- attr(x, "idx_cols")[seq_along(unnamed_dots)]
   new_idx_dims <- setNames(unnamed_dots, index_names)
 }

 if(length(named_dots) > 0) {
   new_idx_dims <- named_dots
 }

 new_idx <- expand_grid(!!! new_idx_dims)

 res <- along_index(x, new_idx) %>%
   idx_tibble()
 res
}


#' Extract from an idx_tbl
#'
#' Always returns an idx_tbl with at least 1 less index dimension than the input, analagous to `[[` with a nested list.
#'
#' @param x idx_tbl
#' @param ... index values to extract
#'
#' @export
#' @examples
#' pop <- idx_tibble(tidyr::population)
#' pop_grow <- pop / idx_extract(pop, year=2000)
idx_extract <- function(x, ...) {

  stopifnot(inherits(x, "idx_tbl"))

  # if any dots are named, all must be named
  # number of dots must be <= number of indexes
  # type of dots must be coercible to corresponding indexes

  dots <- list2(...)

  all_unnamed <- is.null(names(dots))
  unnamed_pos <- names(dots) == ""
  unnamed_dots <- if(all_unnamed) dots else dots[unnamed_pos]
  named_dots <- if(all_unnamed) dots[NULL] else dots[!unnamed_pos]

  if(! xor(length(named_dots) > 0, length(unnamed_dots) > 0)) stop("Index slicing must use *either* named or unnamed args.")

  if(length(unnamed_dots) > 0) {
    index_names <- attr(x, "idx_cols")[seq_along(unnamed_dots)]
    new_idx_dims <- setNames(unnamed_dots, index_names)
  }

  if(length(named_dots) > 0) {
    new_idx_dims <- named_dots
  }

  new_idx <- expand_grid(!!! new_idx_dims)

  sliced <- along_index(x, new_idx)

  #gotta be a better way...all the rest same as slice
  res <- select(sliced, setdiff(names(sliced), names(new_idx))) %>%
    idx_tibble()
  res
}

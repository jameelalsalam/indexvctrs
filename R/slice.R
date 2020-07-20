
#' Slice idx_tbl by index values
#'
#' Analagous to a left-join of the input against a differently shaped index.
#'
#' @param x idx_tbl indexvector
#' @param ... index values to slice. If unnamed, refer to idx_cols of x in order. If named they all must be named, and refer to idx_cols by name.
#'
#' @return idx_tbl with the same axes as input.
#'
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

 res <- along_index(x, new_idx)
 res
}


#' Extract

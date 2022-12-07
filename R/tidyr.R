
# extending select tidyr generics

#' @export
#' @import tidyr
#' @method complete idx_tbl
complete.idx_tbl <- function(data, ..., fill = list()) {

  complete_tibble <- tidyr::complete(tibble::as_tibble(data), ..., fill = fill)

  reconstruct_idx_tibble(data, complete_tibble)
}


#' @export
#' @method unite idx_tbl
unite.idx_tbl <- function(data, col, ..., sep = "_", remove = TRUE, na.rm = FALSE) {

  unite_tibble <- tidyr::unite(tibble::as_tibble(data), {{ col }}, ..., remove = remove, na.rm = na.rm)

  # result will have idx_cols adding `col` parameter (unless it was already in there)
  # if `remove`, then dots variables are not in idx_cols
  # if `value` is combined, then its no longer an idx_tibble though
  # TODO: is some of this actually a modification of reconstruct_idx_tibble?

  non_idx_cols <- setdiff(names(data), idx_cols(data))
  new_col <- rlang::as_string(rlang::ensym(col))
  new_idx_cols <- intersect(setdiff(union(new_col, idx_cols(data)), non_idx_cols), names(unite_tibble))

  new_idx_tibble(unite_tibble, idx_cols = new_idx_cols)
}

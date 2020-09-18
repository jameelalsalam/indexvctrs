
# extending select tidyr generics

#' @export
#' @import tidyr
#' @method complete idx_tbl
complete.idx_tbl <- function(data, ..., fill = list()) {

  complete_tibble <- tidyr::complete(tibble::as_tibble(data), ..., fill = fill)

  reconstruct_idx_tibble(data, complete_tibble)
}

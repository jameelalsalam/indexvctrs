# s3-df-ops.R

# `+.idx_df` <- function(x, y) {
#
#   common_by <- intersect(attr(x, "idx"), attr(y, "idx"))
#
#   new_idx <- union(attr(x, "idx"), attr(y, "idx"))
#
#   join_data <- dplyr::inner_join(dplyr::as_data_frame(x), dplyr::as_data_frame(y), by = common_by) %>%
#     mutate(value = value.x + value.y) %>%
#     select(-value.x, -value.y)
#
#   new_idx_df(join_data, idx = new_idx)
# }

#' @import dplyr
Ops.idx_df <- function(x, y) {
  common_by <- intersect(attr(x, "idx"), attr(y, "idx"))

  new_idx <- union(attr(x, "idx"), attr(y, "idx"))

  join_data <- dplyr::inner_join(dplyr::as_data_frame(x), dplyr::as_data_frame(y), by = common_by) %>%
    mutate(value = rlang::invoke(.Generic, list(value.x, value.y))) %>%
    select(-value.x, -value.y)

  new_idx_df(join_data, idx = new_idx)
}

Math.idx_df <- function(x) {

  new_data <- dplyr::as_data_frame(x) %>%
    rename(old_val = value) %>%
    mutate(value = rlang::invoke(.Generic, list(old_val))) %>%
    select(-old_val)

  new_idx_df(new_data, idx = attr(x, "idx"))
}


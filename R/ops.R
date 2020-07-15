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
#' @import rlang
Ops.idx_df <- function(x, y) {
  common_by <- intersect(attr(x, "idx"), attr(y, "idx"))
  new_idx <- union(attr(x, "idx"), attr(y, "idx"))

  my_exp <- expr((!! sym(.Generic))(value.x, value.y))

  join_data <- dplyr::inner_join(dplyr::as_tibble(x), dplyr::as_tibble(y), by = common_by) %>%
    mutate(value = !!my_exp) %>%
    select(-value.x, -value.y)

  new_idx_df(join_data, idx = new_idx)
}

Math.idx_df <- function(x) {

  my_exp <- expr((!! sym(.Generic))(old_val))

  new_data <- dplyr::as_data_frame(x) %>%
    rename(old_val = value) %>%
    mutate(value = !!my_exp) %>%
    select(-old_val)
  new_idx_df(new_data, idx = attr(x, "idx"))
}

#' sqrt(a)

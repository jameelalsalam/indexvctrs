
# immitating tidyr: https://github.com/tidyverse/tidyr/blob/9c4f9080ce0ae80f3e97ee1f5856ddd4033a0177/R/utils.R

# right now equivalent to dplyr_reconstruct.idx_tibble
# not accounting for potential new cols from e.g., unite, separate, pivot_wider or pivot_longer

reconstruct_idx_tibble <- function(input, output) {

  idx_cols_new <- intersect(names(output), idx_cols(input))
  has_value_col <- "value" %in% names(output)

  if(has_value_col) {
    new_idx_tibble(output, idx_cols = idx_cols_new)
  } else {
    attr(output, "idx_cols") <- NULL
    class(output) <- setdiff(class(output), "idx_tbl")
    output
  }
}

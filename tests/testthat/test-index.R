
library(tibble)

dbl_vec <- c(1, 2)

idx_empty <- idx_tibble(tibble(
  value = c(1, 2)
))


test_that("idx_tibble without idx_cols is equivalent to a vector", {
  expect_null(index(dbl_vec))

  expect_null(index(idx_empty))
})


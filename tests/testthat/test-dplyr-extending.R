
activity <- idx_tibble(
  tibble::tribble(
    ~crop,   ~year, ~value,
    "corn",  2005,  4,
    "corn",  2010,  6,
    "wheat", 2005,  5,
    "wheat", 2010,  8
  ),

  idx_cols = c("crop", "year")
)

test_that("removing index columns with `[` removes from attribute", {

  expect_equal(idx_cols(activity[3]), character(0))
  expect_equal(idx_cols(activity[2:3]), c("year"))
  expect_null(idx_cols(activity[1])) # if value column removes class
  expect_error(activity[4])
})

test_that("removing index columns with dplyr::select removes from attribute", {

  expect_equal(idx_cols(dplyr::select(activity, 3)), character(0))
  expect_equal(idx_cols(dplyr::select(activity, 2:3)), c("year"))
  expect_null(idx_cols(dplyr::select(activity, 1))) # if value column removes class
  expect_error(dplyr::select(activity, 4))
})

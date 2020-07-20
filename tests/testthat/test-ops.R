
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

ef <- idx_tibble(
  tibble::tribble(
    ~crop, ~value,
    "corn", 1.5,
    "wheat", 2
  ),

  idx_cols = "crop"
)

sc <- 3

yr_sc <- c(1, 1.02)

test_that("basics", {
  expect_equal(vctrs::vec_size(activity), 4)
  expect_equal(ncol(activity), 3) # always?

  expect_equal(dplyr::distinct_all(index(activity)), index(activity))
  expect_equal(value(activity), c(4, 6, 5, 8))

})

test_that("idx_tbl %op% idx_tbl works", {
  expect_equal((activity * ef)$value, c(6, 9, 10, 16))
})

test_that("idx_tble %op% scale works", {
  expect_equal((ef * 2)$value, c(3, 4))
})

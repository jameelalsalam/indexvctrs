
activity <- new_idx_vctr(
  tibble::tribble(
    ~crop,   ~year, ~value,
    "corn",  2005,  4,
    "wheat", 2005,  5,
    #"corn",  2010,  6,
    "wheat", 2010,  8
  ),

  idx = c("crop", "year")
)

ef <- new_idx_vctr(
  tibble::tribble(
    ~crop, ~value,
    "corn", 1.5,
    "wheat", 2
  ), idx = "crop"
)

sc <- 3

yr_sc <- c(1, 1.02)

test_that("idx-vctr %op% idx-vctr works", {
  # will change later w/ std order:
  expect_equal((activity * ef)$value == c(6, 10, 9, 16))


})

test_that("idx-vctr %op% scale works", {
  ef * 2
})

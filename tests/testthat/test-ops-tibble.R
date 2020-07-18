
activity <- new_idx_tibble(
  tibble::tribble(
    ~crop,   ~year, ~value,
    "corn",  2005,  4,
    "wheat", 2005,  5,
    "corn",  2010,  6,
    "wheat", 2010,  8
  ),

  idx = c("crop", "year")
)

index(activity)
value(activity)

ef <- new_idx_tibble(
  tibble::tribble(
    ~crop, ~value,
    "corn", 1.5,
    "wheat", 2
  ), idx = "crop"
)

sc <- 3
index(sc)

idx_sc <- along_index(sc, index(activity))
index(idx_sc)
value(idx_sc)

year_sc <- c(1, 1.02)
idx_year_sc <- along_index(year_sc, tibble(year = c(2005, 2010)))
index(idx_year_sc)
value(idx_year_sc)

# idx_tibble op idx_tibble
activity * ef

ef
ef / 1.1

mean(ef)
sloop::s3_dispatch(mean(ef))

test_that("idx-vctr %op% idx-vctr works", {
  # will change later w/ std order:
  expect_equal(value(activity * ef), c(6, 10, 9, 16))


})

test_that("idx-vctr %op% scale works", {
  expect_equal(value(ef * 2), c(3, 4))
})


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



test_that("complete keeps idx_tbl class", {
  complete_act <- tidyr::complete(activity, crop = c("corn", "wheat", "rice"), year)

  expect_s3_class(complete_act, "idx_tbl")
  expect_equal(idx_cols(complete_act), c("crop", "year"))
})

test_that("unite keeps idx_tbl class", {
  unite_act <- tidyr::unite(activity, crop_year, crop, year)

  expect_s3_class(unite_act, "idx_tbl")
  expect_equal(idx_cols(unite_act), "crop_year")
})

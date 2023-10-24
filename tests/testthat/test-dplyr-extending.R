
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



  expect_error(activity[4])
})

test_that("removing value column with `[` removes the class", {

  expect_equal(class(activity[1]), c("tbl_df", "tbl", "data.frame"))
  expect_null(idx_cols(activity[1]))

})

test_that("removing index columns with dplyr::select removes from attribute", {

  expect_equal(idx_cols(dplyr::select(activity, 3)), character(0))
  expect_equal(idx_cols(dplyr::select(activity, 2:3)), c("year"))

  expect_error(dplyr::select(activity, 4))
})

test_that("removing value column with select removes the class", {

  expect_equal(class(dplyr::select(activity, 1)), c("tbl_df", "tbl", "data.frame"))
  expect_null(idx_cols(dplyr::select(activity, 1)))

})

test_that("filter does not change the index", {
  wht <- filter(activity, crop=="wheat")

  expect_equal(idx_cols(wht), c("crop", "year"))
  expect_equal(nrow(wht), 2)
  expect_equal(vctrs::vec_size(wht), 2)
  expect_equal(value(wht), c(5, 8))

  expect_s3_class(wht, "idx_tbl")
})

test_that("group_by does not use these generics, so will need to implement directly", {
  expect_equal(intersect(class(group_by(activity, crop)), "idx_tbl"), character())
})

test_that("renamed idx_col results in correct attribute", {
  act_rename <- dplyr::rename(activity, new_crop = crop)

  expect_equal(idx_cols(act_rename), c("new_crop", "year"))
  expect_s3_class(act_rename, c("idx_tbl"))
})





crop_prod <- indexvctrs::idx_tibble(
  tibble::tribble(
    ~crop,   ~year, ~value,
    "corn",  2005,  4,
    "corn",  2010,  6,
    "wheat", 2005,  5,
    "wheat", 2010,  8
  ))

names(crop_prod) <- c("commodity", "year", "value")

test_that("`names<-` also renames the idx_cols attribute", {

  expect_equal(idx_cols(crop_prod), c("commodity", "year"))

})

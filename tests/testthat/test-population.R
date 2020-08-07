
# try some operations

pop <- idx_tibble(tidyr::population)



test_that("various operations on idx_tbl work", {

  # pull out single value:
  expect_equal(idx_extract(pop, country="United States of America", year=2012)$value, 317505266)

  expect_silent(idx_extract(pop, year=2012) / idx_extract(pop, year=2000))

  expect_silent(idx_slice(pop, "United States of America"))
  expect_silent(idx_extract(pop, "United States of America"))
  expect_silent(pop / idx_slice(pop, year=2000)) # mostly NA because both indexed on year still
  expect_silent(pop / idx_extract(pop, year=2000))

})

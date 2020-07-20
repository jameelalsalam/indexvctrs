
pop <- idx_tibble(tidyr::population)

nrow(index(pop))
length(value(pop))

#pop / idx_slice(pop, year=2000) #what is going on here?

pop / idx_extract(pop, year=2000)

idx_extract(pop, year=2012) / idx_extract(pop, year=2000)

#' pop_grow <- pop / idx_slice(pop, year=2000)

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


pop <- idx_tibble(tidyr::population)

nrow(index(pop))
length(value(pop))

pop / idx_slice(pop, year=2000) # mostly NA because the indexing prevents broadcasting

pop / idx_extract(pop, year=2000)

idx_extract(pop, year=2012) / idx_extract(pop, year=2000)

idx_slice(pop, "United States of America")
idx_extract(pop, "United States of America") %>% attr("idx_cols")

#' pop_grow <- pop / idx_slice(pop, year=2000)

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


#library(sloop)

devtools::load_all(".")

ad <- data.frame(
  key = c("a", "c"),
  value = c(1, 3)
)

ad

# ad[key]

# with_indices(ad[key])

a <- new_idx_df(ad <- data.frame(
  key = c("a", "c"),
  value = c(1, 3)
), "key")

b <- new_idx_df(bd <- data.frame(
  key = c("c", "a"),
  value = c(3, 1)
), "key")

a + b
a - b
a * b
a ^ b
sqrt(a)

`+`(a, b)
`-`(a, b)
`*`(a, b)

mean(a) # errors

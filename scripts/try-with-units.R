library(tidyverse)
library(indexvctrs)
library(units)

prod <- tibble(
  crop = c(rep("corn", 4), rep("wheat", 4)),
  region = rep(c(rep("USA", 2), rep("Mexico", 2)), 2),
  year = rep(c(2005, 2010), 4),
  value = 1:8
) %>%
  mutate(value  = set_units(value, acres)) %>%
  idx_tibble()

install_symbolic_unit("MMTCO2e")

EF <- tibble(
  crop = c("corn", "wheat"),
  value = set_units(c(1, 2), MMTCO2e/acre)
) %>%
  idx_tibble()

emissions <- prod * EF

emissions

idx_extract(emissions, crop = "corn")

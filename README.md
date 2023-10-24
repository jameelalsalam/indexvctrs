
<!-- README.md is generated from README.Rmd. Please edit that file -->

# indexvctrs

<!-- badges: start -->

[![R build
status](https://github.com/jameelalsalam/indexvctrs/workflows/R-CMD-check/badge.svg)](https://github.com/jameelalsalam/indexvctrs/actions)
[![R-CMD-check](https://github.com/jameelalsalam/indexvctrs/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/jameelalsalam/indexvctrs/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of {indexvctrs} is to provide a DSL for indexed vector
operations

Pretty experimental right now!

## Installation

``` r
devtools::install_github("jameelalsalam/indexvctrs")
```

## Example

This package provides `idx_tbl` objects which behave somewhat like
sparse multi-dimensional arrays with named indices, but remain data
frames as well. One of the columns is the `value` column, which is
manipulated directly through math operations.

When `idx_tbl` objects are created, columns are marked as index columns
(the idx_cols attribute), and a single value column is stored as
`value`. Additional columns are dropped.

``` r
library(indexvctrs)

crop_acres <- idx_tibble(
  tibble::tribble(
    ~crop,   ~year, ~value,
    "corn",  2005,  4,
    "wheat", 2005,  5,
    "corn",  2010,  6,
    "wheat", 2010,  8
  ),

  idx_cols = c("crop", "year")
)

EF <- idx_tibble(
  tibble::tribble(
    ~crop, ~value,
    "corn", 1.5,
    "wheat", 2
  ), idx_cols = "crop"
)

idx_cols(crop_acres)
#> [1] "crop" "year"
crop_acres
#> # A tibble: 4 × 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2005     4
#> 2 corn   2010     6
#> 3 wheat  2005     5
#> 4 wheat  2010     8
```

Math operations can be performed between idx_tbls with common indices
via join semantics. The result of this is that where indices do not
share an axis, values are broadcast (or recycled) across that axis. This
applies, for example, to scalars.

``` r
EF * crop_acres
#> # A tibble: 4 × 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2005     6
#> 2 corn   2010     9
#> 3 wheat  2005    10
#> 4 wheat  2010    16
```

``` r
EF * 2
#> # A tibble: 2 × 2
#>   crop  value
#>   <chr> <dbl>
#> 1 corn      3
#> 2 wheat     4
```

It can be convenient to express relationships using functions (e.g., so
that they can be stated out-of-order):

``` r
calc_emissions <- function(activity, EF) {activity * EF}

emissions_by_crop <- calc_emissions(activity = crop_acres, EF = EF * 2)
emissions_by_crop
#> # A tibble: 4 × 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2005    12
#> 2 corn   2010    18
#> 3 wheat  2005    20
#> 4 wheat  2010    32
```

Vector operations act on the `value` column:

``` r
sum(emissions_by_crop)
#> # A tibble: 1 × 1
#>   value
#>   <dbl>
#> 1    82
```

If something isn’t implemented, never fear because you should be able to
drop back to data frame operations.

``` r
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.1     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.3     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.2     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

emissions_by_crop %>%
  filter(year == 2010)
#> # A tibble: 2 × 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2010    18
#> 2 wheat  2010    32
```

## References

I hope that this package benefits from learning from some of these:

- [DSLs](https://adv-r.hadley.nz/translation.html) in adv-R
- S3 object creation from [adv-R](https://adv-r.hadley.nz/s3.html), the
  [vctrs pacakge](https://github.com/r-lib/vctrs), and the [sloop
  package](https://github.com/hadley/sloop)
- exploration of recycling rules in the [{rray}
  package](https://rray.r-lib.org/articles/broadcasting.html)
- related to Einstein summation notation, e.g. in
  [Juilia](https://github.com/ahwillia/Einsum.jl) or
  [Python/Numpy](https://docs.scipy.org/doc/numpy-1.10.0/reference/generated/numpy.einsum.html)


<!-- README.md is generated from README.Rmd. Please edit that file -->

# indexvctrs

The goal of {indexvctrs} is to provide a DSL for indexed vector
operations

Pretty experimental right now\!

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
(the idx\_cols attribute), and a single value column is stored as
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
#> # A tibble: 4 x 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2005     4
#> 2 corn   2010     6
#> 3 wheat  2005     5
#> 4 wheat  2010     8
```

Math operations can be performed between idx\_tbls with common indices
via join semantics. The result of this is that where indices do not
share an axis, values are broadcast (or recycled) across that axis. This
applies, for example, to scalars.

``` r
EF * crop_acres
#> # A tibble: 4 x 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2005     6
#> 2 corn   2010     9
#> 3 wheat  2005    10
#> 4 wheat  2010    16
```

``` r
EF * 2
#> # A tibble: 2 x 2
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
#> # A tibble: 4 x 3
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
#> [1] 82
```

If something isn’t implemented, never fear because you should be able to
drop back to data frame operations.

``` r
library(tidyverse)
#> -- Attaching packages ----------------------------------------------------------- tidyverse 1.3.0 --
#> v ggplot2 3.3.0     v purrr   0.3.4
#> v tibble  3.0.1     v dplyr   0.8.5
#> v tidyr   1.0.2     v stringr 1.4.0
#> v readr   1.3.1     v forcats 0.5.0
#> -- Conflicts -------------------------------------------------------------- tidyverse_conflicts() --
#> x dplyr::filter() masks stats::filter()
#> x dplyr::lag()    masks stats::lag()

emissions_by_crop %>%
  filter(year == 2010)
#> # A tibble: 2 x 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2010    18
#> 2 wheat  2010    32
```

## References

I hope that this package benefits from learning from some of these:

  - [DSLs](https://adv-r.hadley.nz/translation.html) in adv-R
  - S3 object creation from [adv-R](https://adv-r.hadley.nz/s3.html),
    the [vctrs pacakge](https://github.com/r-lib/vctrs), and the [sloop
    package](https://github.com/hadley/sloop)
  - exploration of recycling rules in the [{rray}
    package](https://rray.r-lib.org/articles/broadcasting.html)
  - related to Einstein summation notation, e.g. in
    [Juilia](https://github.com/ahwillia/Einsum.jl) or
    [Python/Numpy](https://docs.scipy.org/doc/numpy-1.10.0/reference/generated/numpy.einsum.html)

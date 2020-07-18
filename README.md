
<!-- README.md is generated from README.Rmd. Please edit that file -->

# indexvctrs

The goal of indexvctrs is to provide a DSL for indexed vector operations

Pretty experimental right now\!

## Installation

``` r
devtools::install_github("jameelalsalam/indexvctrs")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
with_indices({
  Emissions[ghg, fuel] <- fuel_consumption[fuel] * EF[ghg, fuel]
  
  Emissions[ghg] <- sum_over(fuel, Emissions[ghg, fuel])
})
#> Error in with_indices({: could not find function "with_indices"
```

Example equation 2.1 from [IPCC 2006 inventory
GLs](https://www.ipcc-nggip.iges.or.jp/public/2006gl/pdf/2_Volume2/V2_2_Ch2_Stationary_Combustion.pdf)

Under the hood, these objects are actually data frames with additional
attributes indicating which columns are the indices and a `value` column
which is the value. Unlike ‘normal’ vector math, which does matching and
recycling by position, the DSL operations match and recycle along
corresponding indices, akin to joins.

I don’t believe that R really does what I want when recycling vectors
and arrays or arrays of different dimension.

``` r
library(indexvctrs)

crop_acres <- new_idx_tibble(
  tibble::tribble(
    ~crop,   ~year, ~value,
    "corn",  2005,  4,
    "wheat", 2005,  5,
    "corn",  2010,  6,
    "wheat", 2010,  8
  ),

  idx = c("crop", "year")
)

EF <- new_idx_tibble(
  tibble::tribble(
    ~crop, ~value,
    "corn", 1.5,
    "wheat", 2
  ), idx = "crop"
)

calc_emissions <- function(activity, EF) {activity * EF}

emissions_by_crop <- calc_emissions(activity = crop_acres, EF)
emissions_by_crop
#> # A tibble: 4 x 3
#>   crop   year value
#>   <chr> <dbl> <dbl>
#> 1 corn   2005     6
#> 2 wheat  2005    10
#> 3 corn   2010     9
#> 4 wheat  2010    16
```

``` r
sum(emissions_by_crop)
#> [1] 41
```

Representation invariant:

  - To simulate an nd-array, the data must be unique on the combination
    of indices.
  - Only a single ‘value’ column is allowed

## References

I hope to take advantage of learning from:

  - [DSLs](https://adv-r.hadley.nz/translation.html) in adv-R
  - S3 object creation from [adv-R](https://adv-r.hadley.nz/s3.html),
    the [vctrs pacakge](https://github.com/r-lib/vctrs), and the [sloop
    package](https://github.com/hadley/sloop)
  - related to Einstein summation notation, e.g. in
    [Juilia](https://github.com/ahwillia/Einsum.jl) or
    [Python/Numpy](https://docs.scipy.org/doc/numpy-1.10.0/reference/generated/numpy.einsum.html)

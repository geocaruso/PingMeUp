# Compute rank from points

Given a number of points, this function returns the corresponding rank
based on the points–ranking table (`pts_rk_m` (default) or `pts_rk_f`or
any data.frame with columns `pts` and `rk` supplied.

## Usage

``` r
points2rank(p = 1000, pts_rk_mf = pts_rk_m)
```

## Arguments

- p:

  Numeric. Number of points for which to compute the rank.

- pts_rk_mf:

  A data.frame containing columns `pts` (points) and `rk` (rank).
  Defaults to `pts_rk_m`, which must be loaded first using
  `data(pts_rk_m)`.

## Value

Integer rank corresponding to the supplied number of points.

## Examples

``` r
# \donttest{
# Load the default dataset
data(pts_rk_m)

# Compute rank for various point values
points2rank(5000)          # uses pts_rk_m by default
#> [1] 1
points2rank(1500, pts_rk_m)
#> [1] 2001
# }
```

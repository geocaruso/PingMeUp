# Estimates 'Messieurs' classement (B2 to NC) from ranking and number of actifs using a grid of average cumulated share of each classement as of share.m.B2toNC() by default

Estimates 'Messieurs' classement (B2 to NC) from ranking and number of
actifs using a grid of average cumulated share of each classement as of
share.m.B2toNC() by default

## Usage

``` r
rank2classement(x, N_actifs, sh_vector = share.m.B2toNC())
```

## Arguments

- x:

  rank of player

- N_actifs:

  number of active players

- sh_vector:

  cumulated share of each classement, defaulted to share.m.B2toNC()

## Value

a character with the estimated classement, e.g. "D6"

## Examples

``` r
rank2classement(9350,15780)
#> Best guess cumulated percentage based on means across columns of the provided grille. Excludes A's and B0 players as their number is fixed
#> [1] "E2"
rank2classement(9350,16780)
#> Best guess cumulated percentage based on means across columns of the provided grille. Excludes A's and B0 players as their number is fixed
#> [1] "E0"
```

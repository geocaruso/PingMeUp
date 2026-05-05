# Create geom bar of the shares of each classement letter in the AFTT grille

Create geom bar of the shares of each classement letter in the AFTT
grille

## Usage

``` r
geom.pct.classements.grille(grille = share.m.B2toNC(), clr = "deeppink1")
```

## Arguments

- grille:

  Numeric vector. Cumulative shares of each classement in the AFTT
  grille.

- clr:

  Character. Color for the bars representing the shares of each
  classement letter in the AFTT grille. Default: "deeppink1".

## Value

A `ggplot2` layer (geom_errorbar) representing the shares of each
classement letter in the AFTT grille as horizontal bars, to be added to
a plot of the distribution of active players by classement letter.

## Examples

``` r
library(ggplot2)
ggplot()+geom.pct.classements.grille()
#> Best guess cumulated percentage based on means across columns of the provided grille. Excludes A's and B0 players as their number is fixed

```

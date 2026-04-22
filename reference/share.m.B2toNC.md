# Computes the average cumulated percentage by classement from the AFTT classement grille so that classement can be computed for any number of actifs

Computes the average cumulated percentage by classement from the AFTT
classement grille so that classement can be computed for any number of
actifs

## Usage

``` r
share.m.B2toNC(grille = NULL)
```

## Arguments

- grille:

  grille-classements per fixed number of actifs. Defalut is AFTT grille
  classsement: grille_classements_m

## Value

named vector from B2 to NC and their cumulated share of players. When
restimated to known values of the official grid, error is in the margin
of 5 ranks (see example)

## Examples

``` r
share.m.B2toNC()
#> Best guess cumulated percentage based on means across columns of the provided grille. Excludes A's and B0 players as their number is fixed
#>         B2         B4         B6         C0         C2         C4         C6 
#> 0.01401309 0.02930477 0.05519197 0.08863285 0.13417952 0.18883972 0.24648211 
#>         D0         D2         D4         D6         E0         E2         E4 
#> 0.31017066 0.37383439 0.44353663 0.51323887 0.58896380 0.69484683 0.81586661 
#>         E6         NC 
#> 0.96694850 1.00000000 

estim17000 <- share.m.B2toNC()*17000
#> Best guess cumulated percentage based on means across columns of the provided grille. Excludes A's and B0 players as their number is fixed
data("grille_classements_m")
official17000 <- grille_classements_m[3:nrow(grille_classements_m),"actifs_17000"]
estim17000-official17000
#>          B2          B4          B6          C0          C2          C4 
#> -1.77747051 -1.81890920 -1.73655274 -3.24154801 -3.94814586 -4.72481378 
#>          C6          D0          D2          D4          D6          E0 
#> -4.80408813 -2.09883417  0.18458355  0.12268597  0.06078839  2.38458278 
#>          E2          E4          E6          NC 
#>  2.39617667 -0.26763859 -1.87553953  0.00000000 
ceiling(estim17000-official17000)
#> B2 B4 B6 C0 C2 C4 C6 D0 D2 D4 D6 E0 E2 E4 E6 NC 
#> -1 -1 -1 -3 -3 -4 -4 -2  1  1  1  3  3  0 -1  0 
# B2 B4 B6 C0 C2 C4 C6 D0 D2 D4 D6 E0 E2 E4 E6 NC 
# -1 -1 -1 -3 -3 -4 -4 -2  1  1  1  3  3  0 -1  0 
# All are below an error of 5 rank in absolute terms
```

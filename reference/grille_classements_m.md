# AFTT classement grid (Messieurs)

Minimum rank thresholds for each classement category (B2 to NC) for
different numbers of active players ("actifs"), based on the official
AFTT grid.

## Usage

``` r
data(grille_classements_m)
```

## Format

A data frame with rows representing classements (B2, B4, …, NC) and
columns named `actifs_XXXX` giving the minimum rank threshold for that
number of active players.

## Source

AFTT official grid:
<https://aftt.be/wp-content/uploads/2025/02/grille-classements.pdf>

## Examples

``` r
data(grille_classements_m)
head(grille_classements_m)
#>    actifs_14000 actifs_14500 actifs_15000 actifs_15500 actifs_16000
#> A            20           20           20           20           20
#> B0           75           75           75           75           75
#> B2          200          205          210          220          225
#> B4          415          425          440          455          470
#> B6          780          800          830          855          885
#> C0         1250         1285         1330         1375         1420
#>    actifs_16500 actifs_17000 actifs_17500 actifs_18000 actifs_18500
#> A            20           20           20           20           20
#> B0           75           75           75           75           75
#> B2          225          240          245          250          260
#> B4          475          500          515          525          545
#> B6          900          940          970          990         1025
#> C0         1450         1510         1555         1590         1645
#>    actifs_19000 actifs_19500 actifs_20000
#> A            20           20           20
#> B0           75           75           75
#> B2          265          270          280
#> B4          555          570          585
#> B6         1045         1075         1100
#> C0         1680         1725         1770
```

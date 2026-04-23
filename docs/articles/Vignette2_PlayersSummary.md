# Players Summaries

A number of aggregate outputs are pre-computed with `players.summary.R`

## Total and active players

``` r
PingMeUp::count.players()
```

    ## [1] 26164

``` r
PingMeUp::count.actives()
```

    ## [1] 17411

## Active players per province or classement

Actives per province:

``` r
PingMeUp::table.actives.prov()
```

    ## 
    ##    A  BBW    H    L   LK   Lx    N  OVL Vl-B  WVL 
    ## 1151 1542 3672 2529  897 1729 3043 1138  834  876

Actives per classement (detailled or letter)

``` r
PingMeUp::table.actives.class()
```

    ## 
    ##   A1  A11  A12  A13  A14  A15  A16  A19   A2  A20  A21  A22  A23   A3   A4   A5 
    ##    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1 
    ##   A6   A7   A8 As10 As13 As14 As15 As18 As20  As3  As5  As7  As8  As9   B0   B2 
    ##    1    1    1    1    1    1    2    1    1    1    1    1    2    1   64  167 
    ##   B4   B6   C0   C2   C4   C6   D0   D2   D4   D6   E0   E2   E4   E6   NC 
    ##  267  458  572  755  934 1006 1033 1074 1124 1244 1133 1450 1776 1724 2598

``` r
PingMeUp::table.actives.class.l()
```

    ## 
    ##    A    B    C    D    E   NC 
    ##   32  956 3267 4475 6083 2598

``` r
#Where you see 75% of players are D,E or NC
round(100*prop.table(PingMeUp::table.actives.class.l()),digits=2)
```

    ## 
    ##     A     B     C     D     E    NC 
    ##  0.18  5.49 18.76 25.70 34.94 14.92

## Wrapping up and subsets:

A wrapper is made to compute those aggregates.

``` r
PingMeUp::players.summary()
```

    ## $count.players
    ## [1] 26164
    ## 
    ## $count.actives
    ## [1] 17411
    ## 
    ## $table.actives.prov
    ## 
    ##    A  BBW    H    L   LK   Lx    N  OVL Vl-B  WVL 
    ## 1151 1542 3672 2529  897 1729 3043 1138  834  876 
    ## 
    ## $table.actives.class
    ## 
    ##   A1  A11  A12  A13  A14  A15  A16  A19   A2  A20  A21  A22  A23   A3   A4   A5 
    ##    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1 
    ##   A6   A7   A8 As10 As13 As14 As15 As18 As20  As3  As5  As7  As8  As9   B0   B2 
    ##    1    1    1    1    1    1    2    1    1    1    1    1    2    1   64  167 
    ##   B4   B6   C0   C2   C4   C6   D0   D2   D4   D6   E0   E2   E4   E6   NC 
    ##  267  458  572  755  934 1006 1033 1074 1124 1244 1133 1450 1776 1724 2598 
    ## 
    ## $table.actives.class.l
    ## 
    ##    A    B    C    D    E   NC 
    ##   32  956 3267 4475 6083 2598

All can be applied to subsets, for example a club:

``` r
PingMeUp::players.summary(players_m[players_m$club=="N051",])
```

    ## $count.players
    ## [1] 186
    ## 
    ## $count.actives
    ## [1] 111
    ## 
    ## $table.actives.prov
    ## 
    ##   N 
    ## 111 
    ## 
    ## $table.actives.class
    ## 
    ## A14  B0  B2  B4  B6  C0  C2  C4  C6  D0  D2  D4  D6  E0  E2  E4  E6  NC 
    ##   1   4   3   4   7   6   5   6   9  10   4   6   4   8   7  13   4  10 
    ## 
    ## $table.actives.class.l
    ## 
    ##  A  B  C  D  E NC 
    ##  1 18 26 24 32 10

a set of provinces, e.g. French speaking:

``` r
FRprov<-c("BBW","H","L","Lx","N")
PingMeUp::players.summary(players_m[players_m$prov %in% FRprov,])
```

    ## $count.players
    ## [1] 17146
    ## 
    ## $count.actives
    ## [1] 12515
    ## 
    ## $table.actives.prov
    ## 
    ##  BBW    H    L   Lx    N 
    ## 1542 3672 2529 1729 3043 
    ## 
    ## $table.actives.class
    ## 
    ##   A1  A11  A12  A14  A15  A16  A21  A22  A23   A3   A4 As10 As13 As14 As15 As18 
    ##    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1 
    ## As20  As9   B0   B2   B4   B6   C0   C2   C4   C6   D0   D2   D4   D6   E0   E2 
    ##    1    1   42  114  181  348  411  545  685  742  791  797  826  892  875 1146 
    ##   E4   E6   NC 
    ## 1345 1030 1727 
    ## 
    ## $table.actives.class.l
    ## 
    ##    A    B    C    D    E   NC 
    ##   18  685 2383 3306 4396 1727

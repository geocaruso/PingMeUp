# Players Summaries

A number of aggregate outputs are pre-computed with `players.summary.R`

## Total and active players

``` r

library(PingMeUp)
data("players_m", package = "PingMeUp")
```

``` r

count.players()
```

    ## [1] 26197

``` r

count.actives()
```

    ## [1] 17657

## Active players per province or classement

Actives per province:

``` r

table.actives.prov()
```

    ## 
    ##    A  BBW    H    L   LK   Lx    N  OVL Vl-B  WVL 
    ## 1164 1553 3698 2551 1000 1747 3060 1154  847  883

Actives per classement (detailled or letter)

``` r

table.actives.class()
```

    ## 
    ##   A1  A11  A12  A13  A14  A15  A16  A19   A2  A20  A21  A22  A23   A3   A4   A5 
    ##    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1 
    ##   A6   A7   A8 As10 As13 As14 As15 As18 As20  As3  As4  As5  As7  As8  As9   B0 
    ##    1    1    1    1    1    1    2    1    1    1    1    1    1    2    1   64 
    ##   B2   B4   B6   C0   C2   C4   C6   D0   D2   D4   D6   E0   E2   E4   E6   NC 
    ##  168  268  462  576  761  939 1012 1037 1078 1127 1262 1149 1473 1802 1770 2676

``` r

table.actives.class.l()
```

    ## 
    ##    A    B    C    D    E   NC 
    ##   33  962 3288 4504 6194 2676

``` r

#Where you see 75% of players are D,E or NC
round(100*prop.table(PingMeUp::table.actives.class.l()),digits=2)
```

    ## 
    ##     A     B     C     D     E    NC 
    ##  0.19  5.45 18.62 25.51 35.08 15.16

## Wrapping up and subsets:

A wrapper is made to compute those aggregates.

``` r

players.summary()
```

    ## $count.players
    ## [1] 26197
    ## 
    ## $count.actives
    ## [1] 17657
    ## 
    ## $table.actives.prov
    ## 
    ##    A  BBW    H    L   LK   Lx    N  OVL Vl-B  WVL 
    ## 1164 1553 3698 2551 1000 1747 3060 1154  847  883 
    ## 
    ## $table.actives.class
    ## 
    ##   A1  A11  A12  A13  A14  A15  A16  A19   A2  A20  A21  A22  A23   A3   A4   A5 
    ##    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1 
    ##   A6   A7   A8 As10 As13 As14 As15 As18 As20  As3  As4  As5  As7  As8  As9   B0 
    ##    1    1    1    1    1    1    2    1    1    1    1    1    1    2    1   64 
    ##   B2   B4   B6   C0   C2   C4   C6   D0   D2   D4   D6   E0   E2   E4   E6   NC 
    ##  168  268  462  576  761  939 1012 1037 1078 1127 1262 1149 1473 1802 1770 2676 
    ## 
    ## $table.actives.class.l
    ## 
    ##    A    B    C    D    E   NC 
    ##   33  962 3288 4504 6194 2676

All can be applied to subsets, for example a club:

``` r

players.summary(players_m[players_m$club=="N051",])
```

    ## $count.players
    ## [1] 186
    ## 
    ## $count.actives
    ## [1] 113
    ## 
    ## $table.actives.prov
    ## 
    ##   N 
    ## 113 
    ## 
    ## $table.actives.class
    ## 
    ## A14  B0  B2  B4  B6  C0  C2  C4  C6  D0  D2  D4  D6  E0  E2  E4  E6  NC 
    ##   1   4   3   4   7   6   5   6   9  10   4   6   5   8   7  13   5  10 
    ## 
    ## $table.actives.class.l
    ## 
    ##  A  B  C  D  E NC 
    ##  1 18 26 25 33 10

a set of provinces, e.g. French speaking:

``` r

FRprov<-c("BBW","H","L","Lx","N")
players.summary(players_m[players_m$prov %in% FRprov,])
```

    ## $count.players
    ## [1] 17169
    ## 
    ## $count.actives
    ## [1] 12609
    ## 
    ## $table.actives.prov
    ## 
    ##  BBW    H    L   Lx    N 
    ## 1553 3698 2551 1747 3060 
    ## 
    ## $table.actives.class
    ## 
    ##   A1  A11  A12  A14  A15  A16  A21  A22  A23   A3   A4 As10 As13 As14 As15 As18 
    ##    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1 
    ## As20  As9   B0   B2   B4   B6   C0   C2   C4   C6   D0   D2   D4   D6   E0   E2 
    ##    1    1   42  115  181  352  414  550  690  745  794  800  829  901  878 1151 
    ##   E4   E6   NC 
    ## 1350 1036 1763 
    ## 
    ## $table.actives.class.l
    ## 
    ##    A    B    C    D    E   NC 
    ##   18  690 2399 3324 4415 1763

## Number of players and clubs

Number of registered players (active and inactive) per club

``` r

club_n_players <- data.frame(table(players_m$club))
names(club_n_players) <- c("indice","n_players")
club_n_players <- merge(club_n_players, club_registry[,c("indice","label","province")],by="indice")
summary(club_n_players$n_players)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    2.00   30.00   46.00   54.92   70.00  304.00

``` r

library(ggplot2)

ggplot(club_n_players, aes(x = reorder(province, -n_players, FUN = median), y = n_players)) +
  geom_boxplot(fill = "purple") +
  labs(
    title = "Distribution of Club Size by Province",
    x = "Province",
    y = "Number of Players"
  ) +
  theme_minimal()
```

![Distribution of Club Size by
Province](Vignette2_PlayersSummary_files/figure-html/unnamed-chunk-10-1.png)

Distribution of Club Size by Province

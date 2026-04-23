# Retrieve players messieurs list (ranked) for a given club

Submits a POST request to the AFTT club ranking page and extracts the
*Messieurs* ranking. The function isolates the JSON array defining the
rows for the selected club and returns it as a data frame.

## Usage

``` r
get.club.player.list.m(indice)
```

## Arguments

- indice:

  Character string. Club indice (e.g., `"N051"`).

## Value

A data frame containing the players list of the club as of the AFTT
website at the moment of retrieval, sorted by ranking. Column names
follow the structure of the JSON returned by the site but player names
are removed and licence number is used as unique id. Licence number is
extracted from the action field (button) of the html

- position:

  ranking

- position_bis:

  ranking without inactive or 'inactive'

- classement:

  classement at start of season

- club:

  indice club (i.e. same as function argument)

- match:

  number of matches played so far in season

- points:

  points so far in season

- licence:

  licence number extracted from the html action button

## Note

This function scrapes content from the AFTT website
<https://data.aftt.be/ranking/clubs.php> for a single club. Only the
*Messieurs* category is extracted. Uses httr, rvest, stringr, and
jsonlite.

## Examples

``` r
if (FALSE) { # \dontrun{
playersN051 <- get.club.player.list.m("N051")
head(playersN051)
} # }
```

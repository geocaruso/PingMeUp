# Retrieve AFTT club list

Scrapes the AFTT annuaire to extract club indices, names, and provinces.
Province-level entries are excluded and the province is inferred from
the alphabetical prefix of the club index.

## Usage

``` r
get.club.list()
```

## Value

A data frame with columns:

- indice:

  Club index code

- label:

  Club name

- province:

  Province inferred from the index

## Note

Performs a single web request. Uses the rvest package for HTML parsing.

## Examples

``` r
if (FALSE) { # \dontrun{
clubs <- get.club.list()
head(clubs)
} # }
```

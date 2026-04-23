# Build transition and difference tables for two classement vectors

Given two vectors representing old and new classements, this function:

- factorizes both vectors using a supplied classement order (if not
  already factors),

- computes a contingency table of transitions (`transition_table`),

- computes a contingency table of integer differences (`diff_table`).

## Usage

``` r
classement.transitions(
  old,
  new,
  ordre = c("NC", "E6", "E4", "E2", "E0", "D6", "D4", "D2", "D0", "C6", "C4", "C2", "C0",
    "B6", "B4", "B2")
)
```

## Arguments

- old:

  A vector of old/current classements (character or factor).

- new:

  A vector of new classements (character or factor).

- ordre:

  A character vector giving the classement order (default is
  `c("NC","E6","E4","E2","E0","D6","D4","D2","D0","C6","C4","C2","C0","B6","B4","B2")`).

## Value

A list with three elements:

- `transition_table`:

  Contingency table of old vs new classement.

- `diff_table`:

  Contingency table of integer differences.

## Examples

``` r
if (FALSE) { # \dontrun{
  x<-c("D6","E6","E6","D6","E6","E6","D4","C2","B6","C0","D0")
  y<-c("D6","E6","E6","D4","E6","E2","D0","C2","C0","C0","D0")
  tables <- classement.transitions(old = x, new = y, ordre = ordre)
  tables$transition_table
  tables$diff_table
} # }
```

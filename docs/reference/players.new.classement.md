# Compute new classement for a set of players and reports upward/downward movements.

Two new columns are added to the supplied data frame: `classement_new`
(the updated classement) and `classement_diff` (the integer movement
between old and new classement).

## Usage

``` r
players.new.classement(
  players_df = players_m,
  classement_col = "classement",
  ranking_col = "position_bis",
  ordre = c("NC", "E6", "E4", "E2", "E0", "D6", "D4", "D2", "D0", "C6", "C4", "C2", "C0",
    "B6", "B4", "B2")
)
```

## Arguments

- players_df:

  A data frame of players. Defaults to players_m.

- classement_col:

  Column name containing the current classement (default "classement")

- ranking_col:

  Column name containing the current ranking (default "position_bis").

- ordre:

  Vector of ordered classements to be considered.

## Value

A data frame identical to `players_df` but with two additional columns:

- `classement_new`:

  The newly computed classement.

- `classement_diff`:

  Integer difference between new and old classement.

Two attributes are also attached to the returned data frame and
displayed:

- `"transition_table"`:

  Contingency table of old vs new classement.

- `"diff_table"`:

  Contingency table of integer differences.

## Details

In addition to these two columns, the function also constructs
transition and difference tables (via
[`classement.transitions`](https://geocaruso.github.io/PingMeUp/reference/classement.transitions.md)).
These tables are attached as attributes `"transition_table"` and
`"diff_table"` to the returned data frame, and displayed to the console.

Players with classement `"A"`, `"B0"`, or with
`position_bis == "Inactive"` are excluded from the computation and
receive `NA` for both `classement_new` and `classement_diff`.

## Examples

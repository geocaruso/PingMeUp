# Print a directory tree with optional exclusions

Recursively prints the folder structure of a project (typically the
package root), using an ASCII tree layout. Specific folders can be
excluded from the output.

## Usage

``` r
project.tree(path = ".", indent = "", exclude = c("dev"))
```

## Arguments

- path:

  Character string. Root directory to print. Defaults to `"."`.

- indent:

  Internal parameter used for recursive indentation. Users normally do
  not modify this.

- exclude:

  Character vector of folder or file names to exclude (matched against
  [`basename()`](https://rdrr.io/r/base/basename.html)). Defaults to
  `"dev"`.

## Value

Invisibly returns `NULL`. Called for its side effect of printing the
directory tree.

## Examples

``` r
# Print the project tree, excluding the dev/ folder
project.tree(".", exclude = "dev")
#> |--club_registry.html
#> |--count.actives.html
#> |--count.players.html
#> |--get.club.list.html
#> |--get.club.player.list.m.html
#> |--grille_classements_m.html
#> |--index.html
#> |--players.summary.html
#> |--players_m.html
#> \-points2rank.html

# Exclude multiple folders
project.tree(".", exclude = c("dev", ".git", ".Rproj.user"))
#> |--club_registry.html
#> |--count.actives.html
#> |--count.players.html
#> |--get.club.list.html
#> |--get.club.player.list.m.html
#> |--grille_classements_m.html
#> |--index.html
#> |--players.summary.html
#> |--players_m.html
#> \-points2rank.html
```

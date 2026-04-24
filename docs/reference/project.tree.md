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
#> |--classement.transitions.html
#> |--classement.transitions.md
#> |--club_registry.html
#> |--club_registry.md
#> |--club_registry_archive.html
#> |--count.actives.html
#> |--count.actives.md
#> |--count.players.html
#> |--count.players.md
#> |--get.club.list.html
#> |--get.club.list.md
#> |--get.club.player.list.m.html
#> |--get.club.player.list.m.md
#> |--graph.pct.classements-1.png
#> |--graph.pct.classements-2.png
#> |--graph.pct.classements.html
#> |--grille_classements_m.html
#> |--grille_classements_m.md
#> |--index.html
#> |--index.md
#> |--players.new.classement.html
#> |--players.new.classement.md
#> |--players.summary.html
#> |--players.summary.md
#> |--players_f.html
#> |--players_f_archive.html
#> |--players_m.html
#> |--players_m.md
#> |--players_m_archive.html
#> |--points2rank.html
#> |--points2rank.md
#> |--project.tree.html
#> |--project.tree.md
#> |--pts_rk_f.html
#> |--pts_rk_m.html
#> |--pts_rk_m.md
#> |--rank2classement.html
#> |--rank2classement.md
#> |--share.m.B2toNC.html
#> |--share.m.B2toNC.md
#> |--table.actives.class.html
#> |--table.actives.class.l.html
#> |--table.actives.class.l.md
#> |--table.actives.class.md
#> |--table.actives.prov.html
#> \-table.actives.prov.md

# Exclude multiple folders
project.tree(".", exclude = c("dev", ".git", ".Rproj.user"))
#> |--classement.transitions.html
#> |--classement.transitions.md
#> |--club_registry.html
#> |--club_registry.md
#> |--club_registry_archive.html
#> |--count.actives.html
#> |--count.actives.md
#> |--count.players.html
#> |--count.players.md
#> |--get.club.list.html
#> |--get.club.list.md
#> |--get.club.player.list.m.html
#> |--get.club.player.list.m.md
#> |--graph.pct.classements-1.png
#> |--graph.pct.classements-2.png
#> |--graph.pct.classements.html
#> |--grille_classements_m.html
#> |--grille_classements_m.md
#> |--index.html
#> |--index.md
#> |--players.new.classement.html
#> |--players.new.classement.md
#> |--players.summary.html
#> |--players.summary.md
#> |--players_f.html
#> |--players_f_archive.html
#> |--players_m.html
#> |--players_m.md
#> |--players_m_archive.html
#> |--points2rank.html
#> |--points2rank.md
#> |--project.tree.html
#> |--project.tree.md
#> |--pts_rk_f.html
#> |--pts_rk_m.html
#> |--pts_rk_m.md
#> |--rank2classement.html
#> |--rank2classement.md
#> |--share.m.B2toNC.html
#> |--share.m.B2toNC.md
#> |--table.actives.class.html
#> |--table.actives.class.l.html
#> |--table.actives.class.l.md
#> |--table.actives.class.md
#> |--table.actives.prov.html
#> \-table.actives.prov.md
```

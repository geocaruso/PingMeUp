#' AFTT classement grid (Messieurs)
#'
#' Minimum rank thresholds for each classement category (B2 to NC)
#' for different numbers of active players ("actifs"), based on the
#' official AFTT grid.
#'
#' @format A data frame with rows representing classements (B2, B4, …, NC)
#'   and columns named `actifs_XXXX` giving the minimum rank threshold
#'   for that number of active players.
#'
#' @usage data(grille_classements_m)
#'
#' @source AFTT official grid:
#'   \url{https://aftt.be/wp-content/uploads/2025/02/grille-classements.pdf}
#'
#' @examples
#' data(grille_classements_m)
#' head(grille_classements_m)
"grille_classements_m"

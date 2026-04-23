#' Count total players
#'
#' @param players A players data.frame. Defaults to `players_m`, but you may
#'   supply `players_f` or any archived snapshot such as
#'   `players_m_archive[["YYYY_MM"]]` or `players_f_archive[["YYYY_MM"]]`.
#' @return Integer: number of players.
#' @export
count.players <- function(players = NULL) {
  if (is.null(players)) {
    data("players_m", package = "PingMeUp")
    players <- players_m
  }
  nrow(players)
}

#' Count active players
#'
#' @param players A players data.frame. Defaults to `players_m`, but you may
#'   supply `players_f` or any archived snapshot.
#' @return Integer: number of active players.
#' @export
count.actives <- function(players = NULL) {
  if (is.null(players)) {
    data("players_m", package = "PingMeUp")
    players <- players_m
  }
  
  sum(players$position_bis != "Inactive")
}

#' Active players per province
#'
#' @param players A players data.frame. Defaults to `players_m`, but you may
#'   supply `players_f` or any archived snapshot.
#' @return A table of active players by province.
#' @export
table.actives.prov <- function(players = NULL) {
  if (is.null(players)) {
    data("players_m", package = "PingMeUp")
    players <- players_m
  }
  
  table(players$prov[players$position_bis != "Inactive"])
}

#' Active players per classement
#'
#' @param players A players data.frame. Defaults to `players_m`, but you may
#'   supply `players_f` or any archived snapshot.
#' @return A table of active players by classement.
#' @export
table.actives.class <- function(players = NULL) {
  if (is.null(players)) {
    data("players_m", package = "PingMeUp")
    players <- players_m
  }

  table(players$classement[players$position_bis != "Inactive"])
}

#' Active players per classement letter
#'
#' @param players A players data.frame. Defaults to `players_m`, but you may
#'   supply `players_f` or any archived snapshot.
#' @return A table of active players by classement letter.
#' @export
table.actives.class.l <- function(players = NULL) {
  if (is.null(players)) {
    data("players_m", package = "PingMeUp")
    players <- players_m
  }
  
  table(players$classement_lettre[players$position_bis != "Inactive"])
}


#' Summary (wrapper) of player counts and tables
#'
#' @param players A players data.frame. Defaults to `players_m`, but you may
#'   supply `players_f` or any archived snapshot.
#' @return A list containing counts and tables for the supplied dataset.
#' @export
players.summary <- function(players = NULL) {
  if (is.null(players)) {
    data("players_m", package = "PingMeUp")
    players <- players_m
  }
  
  list(
    count.players         = count.players(players),
    count.actives         = count.actives(players),
    table.actives.prov    = table.actives.prov(players),
    table.actives.class   = table.actives.class(players),
    table.actives.class.l = table.actives.class.l(players)
  )
}

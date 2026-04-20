#' Estimates 'Messieurs' classement (B2 to NC) from ranking and number of actifs using a grid of average cumulated share of each classement as of share.m.B2toNC() by default
#'
#' @param x rank of player 
#' @param N_actifs number of active players
#' @param sh_vector cumulated share of each classement, defaulted to share.m.B2toNC()
#'
#' @returns a character with the estimated classement, e.g. "D6"
#' @export
#'
#' @examples
#' get.classement.m.from.rank(9350,15780)
#' get.classement.m.from.rank(9350,16780)
#' 
get.classement.m.from.rank <- function(x, N_actifs,
                                       sh_vector = share.m.B2toNC()) {
  Actifs2RankClassGrid <- ceiling(sh_vector * N_actifs / 5) * 5
  
  names(Actifs2RankClassGrid)[findInterval(x, c(0, Actifs2RankClassGrid), rightmost.closed = TRUE)]
}

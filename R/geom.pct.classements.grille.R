#' Create geom bar of the shares of each classement letter in the AFTT grille
#'
#' @param grille Numeric vector. Cumulative shares of each classement in the AFTT grille.
#' @param clr Character. Color for the bars representing the shares of each classement letter in the AFTT grille. Default: "deeppink1".
#'
#' @returns A \code{ggplot2} layer (geom_errorbar) representing the shares of each classement letter in the AFTT grille as horizontal bars, to be added to a plot of the distribution of active players by classement letter.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot()+geom.pct.classements.grille()
#' 
geom.pct.classements.grille <- function(grille = share.m.B2toNC(),clr="deeppink1") {
  AFTT_grille_shares <- data.frame(
    classement = names(grille),
    classement_lettre = substring(names(grille), 1, 1),
    cumul_sh = grille,
    sh = diff(c(0, grille))
  )
  AFTT_letters_shares <- aggregate(sh ~ classement_lettre, data = AFTT_grille_shares, FUN = sum)
  AFTT_letters_shares[AFTT_letters_shares$classement_lettre == "N", "classement_lettre"] <- "NC"
  AFTT_letters_shares
  
  aftt_grille_sh_bar <- geom_errorbar(
    data = AFTT_letters_shares,
    aes(x     = classement_lettre, ymin  = sh, ymax  = sh),
    width = 0.5,
    # controls horizontal length
    color = clr,
    linewidth = 1,
    alpha = 0.7,
    inherit.aes = FALSE
  )
  
  return(aftt_grille_sh_bar)
}

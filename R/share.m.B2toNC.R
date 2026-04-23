#' Computes the average cumulated percentage by classement from the AFTT classement grille so that classement can be computed for any number of actifs
#'
#' @param grille grille-classements per fixed number of actifs. Defalut is AFTT grille classsement: grille_classements_m
#'
#' @returns named vector from B2 to NC and their cumulated share of players. When reestimated to known values of the official grid, error is in the margin of 5 ranks (see example)
#' 
#' @export
#' 
#' @importFrom utils data
#'
#' @examples
#' share.m.B2toNC()
#' 
#' estim17000 <- share.m.B2toNC()*17000
#' data("grille_classements_m")
#' official17000 <- grille_classements_m[3:nrow(grille_classements_m),"actifs_17000"]
#' estim17000-official17000
#' ceiling(estim17000-official17000)
#' # B2 B4 B6 C0 C2 C4 C6 D0 D2 D4 D6 E0 E2 E4 E6 NC 
#' # -1 -1 -1 -3 -3 -4 -4 -2  1  1  1  3  3  0 -1  0 
#' # All are below an error of 5 rank in absolute terms
#' 
share.m.B2toNC<-function(grille=NULL){
  
  #if NULL then use grille_classements_m from environement (loaded with package as it is in data folder)
    if (is.null(grille)) {
      data("grille_classements_m", envir = environment())
      grille <- grille_classements_m
  }
  
  grille_m_sh<-apply(grille, 2, function(x) x / x[nrow(grille)])
  
  message("Best guess cumulated percentage based on means across columns of the provided grille. Excludes A's and B0 players as their number is fixed")
  
  ShareB2toNC<-rowMeans(grille_m_sh)[-(1:2)] 
  
  return(ShareB2toNC)
}
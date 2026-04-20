#' Build the AFTT grille-classements as a data-frame
#'
#' @returns A data frame with classements as rows and the corresponding minimum rank as columns based on the number of "actifs". See grille-classements-messieurs-aftt.txt" for text version made from original https://aftt.be/wp-content/uploads/2025/02/grille-classements.pdf
#' 
#' @export
#'
#' @examples
#' 
build.grille.classements.m <- function() {
  grille_classements_m <- read.delim(
    "data-raw/grillesAFTT/grille-classements-messieurs-aftt.txt",
    header = FALSE,
    sep = " "
  )
  names(grille_classements_m) <- paste0("actifs_", grille_classements_m[nrow(grille_classements_m), ])
  rownames(grille_classements_m) <- grille_classements_m[, 1]
  grille_classements_m <- grille_classements_m[, -1]
  
  # Save
  message("grille_classements_m saved as RDA")
  save(grille_classements_m, file = "data/grille_classements_m.rda")
  
  invisible(grille_classements_m)
}

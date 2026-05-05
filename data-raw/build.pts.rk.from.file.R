#' Build points–ranking dataset from stored players file
#'
#' Wrapper around `build.pts.rk()` to load the corresponding
#' `players_*.rda` file (not any current pa-layers data frame
#' in the global environement) from the `data` directory and generates
#' the points–ranking outputs.
#'
#' @param mf Character, either `"m"` (Messieurs) or `"f"` (Dames).
#'
#' @return Invisibly returns the data.frame produced by `build.pts.rk()`.
#' @export
build.pts.rk.from.file <- function(mf = "m") {
  file_path <- file.path("data", paste0("players_", mf, ".rda"))
  
  e <- new.env()
  load(file_path, envir = e)
  
  players <- e[[ls(e)[1]]]
  
  build.pts.rk(mf, players = players)
}

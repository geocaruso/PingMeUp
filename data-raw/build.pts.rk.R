#' Build and export the points–ranking dataset (Messieurs or Dames) for use in Classment from points computation (online with json or local with rda)
#'
#' Extracts the points–ranking list from a players data.frame, keeps only
#' active players, renames the columns to `pts` and `rk`, and exports the
#' result as JSON and `.rda`.
#'
#' @param mf Either `"m"` (Messieurs) or `"f"` (Dames). Determines default
#'   dataset and output filenames.
#' @param players A players data.frame. If NULL, defaults to `players_m`
#'   when `mf = "m"` and to `players_f` when `mf = "f"`. You may also
#'   supply archived snapshots such as `players_m_archive[["YYYY_MM"]]`.
#' @param json_dir Directory for JSON output. Defaults to `"inst/app"`.
#' @param rda_dir Directory for `.rda` output. Defaults to `"data"`.
#'
#' @return Invisibly returns the data.frame used to generate the files.
#' @export
build.pts.rk <- function(mf = "m",
                         players = NULL,
                         json_dir = "data-raw",
                         rda_dir  = "data") {
  
  # Validate mf
  if (!mf %in% c("m", "f"))
    stop("mf must be 'm' or 'f'")
  
  # Choose default dataset if none supplied
  if (is.null(players)) {
    players <- if (mf == "m") players_m else players_f
  }
  
  # Output filenames ALWAYS include _m or _f
  json_path <- file.path(json_dir, paste0("pts_rk_", mf, ".json"))
  rda_path  <- file.path(rda_dir,  paste0("pts_rk_", mf, ".rda"))
  
  # Subset active players
  pts_rk <- players[players$position_bis != "Inactive",
                    c("points", "position_bis")]
  
  # Rename columns
  pts_rk <- data.frame(
    pts = pts_rk$points,
    rk  = as.integer(pts_rk$position_bis)
  )
  
  # Write JSON
  jsonlite::write_json(
    pts_rk,
    json_path,
    pretty = TRUE,
    auto_unbox = TRUE
  )
  
  # Write RDA
  objname <- paste0("pts_rk_", mf) #this and assign needed otherwise rda object name is generic ie pts_rk not with _m or _f
  assign(objname, pts_rk)
  save(list = objname, file = rda_path)
  
  invisible(pts_rk)
}

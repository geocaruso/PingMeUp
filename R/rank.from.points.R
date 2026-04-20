#' Compute rank from points
#'
#' Given a number of points, this function returns the corresponding
#' rank based on the points–ranking table (`pts_rk_m` (default) or
#' `pts_rk_f`or any data.frame with columns `pts` and `rk` supplied.
#'
#' @param p Numeric. Number of points for which to compute the rank.
#' @param pts_rk_mf A data.frame containing columns `pts` (points) and
#'   `rk` (rank). Defaults to `pts_rk_m`, which must be loaded first
#'   using `data(pts_rk_m)`.
#'
#' @return Integer rank corresponding to the supplied number of points.
#' @export
#'
#' @examples
#' \donttest{
#' # Load the default dataset (CRAN-standard workflow)
#' data(pts_rk_m)
#'
#' # Compute rank for various point values
#' rank.from.points(5000)          # uses pts_rk_m by default
#' rank.from.points(1500, pts_rk_m)
#' }
#' 
rank.from.points <- function(p = 1000, pts_rk_mf = pts_rk_m) {
  names(pts_rk_mf) <- c("pts", "rk")
  
  pts_rk_mf <- pts_rk_mf[order(pts_rk_mf$pts, decreasing = TRUE), ]
  pts_rk_mf$rk <- as.integer(pts_rk_mf$rk)
  
  above_p <- which(pts_rk_mf$pts > p)
  
  if (length(above_p) == 0)
    return(min(pts_rk_mf$rk))
  
  pos_above <- max(pts_rk_mf$rk[above_p])
  pos_above + 1
}

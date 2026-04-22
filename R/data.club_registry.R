#' Club Registry (Latest Snapshot) and Archive
#'
#' These datasets store the latest and archived snapshots of the AFTT club
#' registry as produced by `build.clubs.registry()`.
#'
#' @details
#' * `club_registry` is a data frame containing the latest** snapshot.
#'   It includes attributes:
#'   - `year`: snapshot year
#'   - `month`: snapshot month
#'   - `html_raw`: list of raw HTML pages used to build the snapshot
#'
#' * `club_registry_archive` is a **named list** of past snapshots.
#'   Each element is named `"YYYY_MM"` and contains a data frame with the
#'   same structure and attributes as `club_registry`.
#'
#' @examples
#' # Load the latest snapshot
#' data(club_registry)
#' club_registry
#'
#' # Load the archive list
#' data(club_registry_archive)
#'
#' # List available archived snapshots
#' names(club_registry_archive)
#'
#' # Access a specific archived snapshot
#' club_registry_archive[["2026_04"]]
#'
#' @name club_registry
#' @aliases club_registry_archive
#' @docType data
NULL

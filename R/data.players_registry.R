#' Players Registry (Latest Snapshot) and Archive
#'
#' These datasets store the latest and archived snapshots of the AFTT
#' players registry (Messieurs and Dames) as produced by
#' `build.players.registry.m()` and `build.players.registry.f()`.
#'
#' @details
#' ## Latest snapshots
#'
#' * `players_m` and `players_f` are data frames containing the **latest**
#'   snapshot for Messieurs and Dames respectively.  
#'
#'   Each snapshot data frame includes the following columns:
#'
#'   - `"position"`: current AFTT ranking of the player  
#'   - `"position_bis"`: ranking excluding inactive players  
#'   - `"nom"` (if requested): player's name  
#'   - `"classement"`: classement at start of season (or after mid‑season reevaluation)  
#'   - `"club"`: club indice  
#'   - `"match"`: number of matches played  
#'   - `"points"`: points earned so far (basis for ranking)  
#'   - `"licence"`: unique player ID  
#'   - `"prov"`: province of the club  
#'   - `"classement_lettre"`: classement letter (A, B, C, D, E, NC)  
#'   - `"classement_chiffre"`: classement number (0, 2, 4, 6; 99 for A and NC)  
#'   - `"position_bis_p"`: ranking of the player within their province  
#'
#'   Each snapshot also includes attributes:
#'   - `year`: snapshot year  
#'   - `month`: snapshot month  
#'   - `retrieved`: POSIXct timestamp of retrieval  
#'
#' ## Archives
#'
#' * `players_m_archive` and `players_f_archive` are **named lists** of past snapshots.
#'   Each element is named `"YYYY_MM"` and contains a data frame with the
#'   same structure and attributes as the corresponding latest snapshot.
#'
#' @examples
#' \dontrun{
#' data(players_m)
#' head(players_m)
#' data(players_m_archive)
#' names(players_m_archive)
#' players_m_archive[["2026_04"]]
#' data(players_f)
#' head(players_f)
#' data(players_f_archive)
#' names(players_f_archive)
#' players_f_archive[["2026_04"]]
#' }
#'
#' @name players_m
#' @aliases players_m_archive players_f players_f_archive
#' @docType data
NULL

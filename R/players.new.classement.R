#' Compute new classement for a set of players and reports upward/downward movements.
#' 
#' Two new columns are added to the supplied data frame: \code{classement_new} (the updated classement) and
#' \code{classement_diff} (the integer movement between old and new classement).
#'
#' In addition to these two columns, the function also constructs transition and
#' difference tables (via \code{\link{classement.transitions}}). These tables are attached as attributes \code{"transition_table"} and \code{"diff_table"} to the returned data frame, and displayed to the console.
#'   
#' Players with classement `"A"`, `"B0"`, or with
#' `position_bis == "Inactive"` are excluded from the computation and receive
#' `NA` for both `classement_new` and `classement_diff`.
#'
#' @param players_df A data frame of players. Defaults to players_m.
#' @param classement_col Column name containing the current classement (default "classement")
#' @param ranking_col Column name containing the current ranking 
#'        (default "position_bis").
#' @param ordre Vector of ordered classements to be considered.
#'
#' @return
#' A data frame identical to \code{players_df} but with two additional columns:
#' \describe{
#'   \item{\code{classement_new}}{The newly computed classement.}
#'   \item{\code{classement_diff}}{Integer difference between new and old
#'         classement.}
#' }
#'
#' Two attributes are also attached to the returned data frame and displayed:
#' \describe{
#'   \item{\code{"transition_table"}}{Contingency table of old vs new classement.}
#'   \item{\code{"diff_table"}}{Contingency table of integer differences.}
#' }
#' 
#' 
#' @examples
#' \dontrun{
#' Default: full dataset of players i.e. players_m
#' res <- players.new.classement()
#' 
#' Subset example: by club 
#' players_N051 <- subset(players_m, club == "N051")
#' resN051 <- players.new.classement(players_N051)
#' }
#'   
#' @export
players.new.classement <- function(players_df = players_m,
                                   classement_col="classement",
                                   ranking_col = "position_bis",
                                   ordre = c("NC","E6","E4","E2","E0",
                                             "D6","D4","D2","D0",
                                             "C6","C4","C2","C0",
                                             "B6","B4","B2")){
  
  # --- Validate required columns ---
  if (!classement_col %in% names(players_df)) {
    stop("Column '", classement_col, "' not found in players_df.")
  }
  if (!ranking_col %in% names(players_df)) {
    stop("Column '", ranking_col, "' not found in players_df.")
  }
  
  # --- Check classement_lettre exists otherwise make it ---
  if (!"classement_lettre" %in% names(players_df)) {
    players_df$classement_lettre <- substr(players_df[[classement_col]], 1, 1)
    players_df$classement_lettre[players_df[[classement_col]] == "NC"] <- "N"
  }
  
  # --- Prepare output ---
  out <- players_df
  
  # Initialise output columns as NA
  out$classement_new  <- NA_character_
  out$classement_diff <- NA_integer_
  
  # --- Identify rows to keep for computation ---
  keep <- out$classement_lettre != "A" &
    out[[classement_col]] != "B0" &
    out[[ranking_col]] != "Inactive"
  
  # --- Compute new classement only for kept rows ---
  new_cl <- rank2classement(
    as.numeric(out[[ranking_col]][keep]),
    count.actives()
  )
  
  # E6+ cannot become NC
  old_cl <- out[[classement_col]][keep]
  new_cl[old_cl != "NC" & new_cl == "NC"] <- "E6"
  
  out$classement_new[keep] <- new_cl
  
  # --- Compute classement differences ---
  old_f <- factor(out[[classement_col]][keep], levels = ordre, ordered = TRUE)
  new_f <- factor(out$classement_new[keep], levels = ordre, ordered = TRUE)
  
  out$classement_diff[keep] <- as.integer(new_f) - as.integer(old_f)
  
  
  # Attach transition and diff tables as attributes
  tables <- classement.transitions(
    old = old_f,
    new = new_f,
    ordre = ordre
  )
  
  attr(out, "transition_table") <- tables$transition_table
  attr(out, "diff_table")       <- tables$diff_table
  
  return(out)
}

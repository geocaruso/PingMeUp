#' Build transition and difference tables for two classement vectors
#'
#' Given two vectors representing old and new classements, this function:
#' \itemize{
#'   \item factorizes both vectors using a supplied classement order (if not already factors),
#'   \item computes a contingency table of transitions (\code{transition_table}),
#'   \item computes a contingency table of integer differences (\code{diff_table}).
#' }
#'
#' @param old A vector of old/current classements (character or factor).
#' @param new A vector of new classements (character or factor).
#' @param ordre A character vector giving the classement order
#'   (default is \code{c("NC","E6","E4","E2","E0","D6","D4","D2","D0","C6","C4","C2","C0","B6","B4","B2")}).
#'
#' @return A list with three elements:
#' \describe{
#'   \item{\code{transition_table}}{Contingency table of old vs new classement.}
#'   \item{\code{diff_table}}{Contingency table of integer differences.}
#' }
#'
#' @examples
#' \dontrun{
#'   x<-c("D6","E6","E6","D6","E6","E6","D4","C2","B6","C0","D0")
#'   y<-c("D6","E6","E6","D4","E6","E2","D0","C2","C0","C0","D0")
#'   tables <- classement.transitions(old = x, new = y, ordre = ordre)
#'   tables$transition_table
#'   tables$diff_table
#' }
#'
#' @export
classement.transitions <- function(old, new,
                              ordre=c("NC","E6","E4","E2","E0",
                                      "D6","D4","D2","D0",
                                      "C6","C4","C2","C0",
                                      "B6","B4","B2")) {
  
  # Factorize only if not already factors with correct levels
  if (!is.factor(old) || !identical(levels(old), ordre)) {
    old <- factor(old, levels = ordre, ordered = TRUE)
  }
  if (!is.factor(new) || !identical(levels(new), ordre)) {
    new <- factor(new, levels = ordre, ordered = TRUE)
  }
  
  # Transition table
  transition_table <- addmargins(table(old, new))
  transition_table[transition_table==0]<-"."
  
  # Difference table 
  diff_table <- addmargins(table(as.integer(new) - as.integer(old)))
  
  
  # Display transition and diff tables as messages
  message("\nTransition table:\n",
          paste(capture.output(print(transition_table)), collapse = "\n"))
  
  message("\nDifference table (number of players upward/downward by):\n",
          paste(capture.output(print(diff_table)), collapse = "\n"))
  
  #output
  list(
    transition_table = transition_table,
    diff_table = diff_table
  )
}

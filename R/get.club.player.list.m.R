#' Retrieve players messieurs list (ranked) for a given club
#'
#' Submits a POST request to the AFTT club ranking page and extracts the
#' *Messieurs* ranking. The function isolates the JSON array defining
#' the rows for the selected club and returns it as a data frame.
#'
#' @param indice Character string. Club indice (e.g., `"N051"`).
#'
#' @return A data frame containing the players list of the club 
#' as of the AFTT website at the moment of retrieval, sorted by ranking.
#' Column names follow the structure of the JSON returned by the site but player names are removed and licence number is used as unique id. Licence number is extracted from the action field (button) of the html
#' \describe{
#'     \item{position}{ranking}
#'     \item{position_bis}{ranking without inactive or 'inactive'}
#'     \item{classement}{classement at start of season}
#'     \item{club}{indice club (i.e. same as function argument)}
#'     \item{match}{number of matches played so far in season}
#'     \item{points}{points so far in season}
#'     \item{licence}{licence number extracted from the html action button}
#'   }
#'
#' @note
#' This function scrapes content from the AFTT website
#' \url{https://data.aftt.be/ranking/clubs.php} for a single club.  
#' Only the *Messieurs* category is extracted.  
#' Uses \pkg{httr}, \pkg{rvest}, \pkg{stringr}, and
#' \pkg{jsonlite}.  
#'
#' @examples
#' \dontrun{
#' playersN051 <- get.club.player.list.m("N051")
#' head(playersN051)
#' }
#'
#' @export
get.club.player.list.m <- function(indice) {
  
  # 1. POST request for the selected club
  res <- httr::POST(
    url   = "https://data.aftt.be/ranking/clubs.php",
    body  = list(indice = indice),
    encode = "form"
  )
  
  html <- rvest::read_html(httr::content(res, "text", encoding = "UTF-8"))
  
  # 2. Extract all <script> blocks
  nodes <- rvest::html_elements(html, "script")
  scripts <- rvest::html_text(nodes)
  
  # 3. Identify the script containing the Messieurs rows definition
  target <- scripts[stringr::str_detect(
    scripts,
    "rows: category === \"Messieurs\""
  )]
  
  if (length(target) == 0)
    stop("No script with Messieurs rows found")
  
  target <- target[1]
  
  # 4. Cut from the 'rows: category === "Messieurs"' section onward
  start <- regexpr("rows: category === \"Messieurs\"", target, fixed = TRUE)
  subtxt <- substring(target, start)
  
  # 5. Locate the first '[' after that
  open_pos <- regexpr("[", subtxt, fixed = TRUE)
  
  # 6. Locate the end of the Messieurs array
  end_marker <- regexpr("}] :", subtxt, fixed = TRUE)
  if (end_marker == -1)
    stop("End of Messieurs array not found")
  
  close_pos <- end_marker + 1  # include the closing ']'
  
  # 7. Extract the JSON array text
  json_text <- substring(subtxt, open_pos, close_pos)
  
  # 8. Parse JSON into a data frame
  df <- jsonlite::fromJSON(json_text)
  
  # 9. Use last column (action link) to retrieve licence number and use as player id. Removes action field.
  df$licence <- sub('.*value="([0-9]+)".*', '\\1', df$action)
  df$action <- NULL
  #df$nom <- NULL #TOGGLE ON TO REMOVE NAMES
  
  return(df)
}

#' Retrieve AFTT club list
#'
#' Scrapes the AFTT annuaire to extract club indices, names, and provinces.
#' Province-level entries are excluded and the province is inferred from
#' the alphabetical prefix of the club index.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{indice}{Club index code}
#'     \item{label}{Club name}
#'     \item{province}{Province inferred from the index}
#'   }
#'
#' @note
#' Performs a single web request. Uses the \pkg{rvest} package for
#' HTML parsing.
#' 
#' @seealso \code{build.club.registry} in \code{data-raw/} which calls this function internally.
#'
#' @examples
#' \dontrun{
#' clubs <- get.club.list()
#' head(clubs)
#' }
#' 
#' @export

get.club.list <- function() {
  # URL annuaire clubs
  url <- "https://data.aftt.be/annuaire/membres.php"
  
  # Read page
  page <- rvest::read_html(url)
  # Extract all <option> nodes inside the <select name="indice">
  opts <- rvest::html_elements(page, "select[name='indice'] option")
  
  # Extract values and labels
  indices <- rvest::html_attr(opts, "value")
  labels  <- rvest::html_text(opts, trim = TRUE)
  
  # Remove those not corresponding to a club indice
  # code must finish with 3 numbers otherwise it is province or other
  keep <- grepl("[0-9]{3}$", indices) &
    !grepl("000$", indices) #indicates province
  
  indices <- indices[keep]
  labels  <- labels[keep]
  
  # Assemble into data.frame
  club_list <- data.frame(indice = indices,
                          label  = labels,
                          stringsAsFactors = FALSE)
  
  # Add province from indice (removing numbers from indice)
  club_list[, "province"] <- gsub("[0-9]+", "", club_list[, "indice"])
  
  #message nrows
  message(paste("Club list with", nrow(club_list), "clubs."))
  
  return(club_list)
}

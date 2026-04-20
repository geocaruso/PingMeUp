#get_club_info.R

#OK THIS WORKS BUT IN THIS INVENTAIRE PART THE LIST OF PLAYERS IS NOT UP TO DATE!!
#IT IS FROM AT LEAST ON YEAR. SO SHOULD LOOP IN ANNUAIRE FOR LOCATION OF CLUBS
# BUT NOT FO R DATA ABOUT ON PLAYERS

library(httr)
library(rvest)

get_club_info <- function(indice) {
  
  # 1. POST request
  res <- httr::POST(
    url = "https://data.aftt.be/annuaire/membres.php",
    body = list(indice = indice),
    encode = "form"
  )
  
  # 2. Extract raw HTML as text
  html_raw <- httr::content(res, "text", encoding = "UTF-8")
  
  # 3. Save raw HTML text to disk
  html_file <- file.path("html", paste0(indice, ".html"))
  writeLines(html_raw, html_file)
  
  # 4. Parse HTML
  page <- read_html(html_raw)
  
  # 5. Extract all tables
  tables <- html_elements(page, "table")
  
  players <- NULL
  
  # 6. Identify the players table by its column names
  for (tbl in tables) {
    df <- try(html_table(tbl, fill = TRUE), silent = TRUE)
    
    if (!inherits(df, "try-error")) {
      if (ncol(df) == 5 &&
          all(c("#", "Licence", "Nom", "Catégorie", "Classement") %in% names(df))) {
        players <- df
        break
      }
    }
  }
  
  # 7. If no players table found, save empty RDS and return NA summary
  if (is.null(players)) {
    saveRDS(NULL, file.path("rds", paste0(indice, "_players.rds")))
    return(list(
      indice = indice,
      n_players = NA,
      first_classement = NA,
      players_file = file.path("rds", paste0(indice, "_players.rds")),
      html_file = html_file
    ))
  }
  
  # 8. Save players table as RDS
  rds_file <- file.path("rds", paste0(indice, "_players.rds"))
  saveRDS(players, rds_file)
  
  # 9. Extract summary fields
  n_players <- nrow(players)
  first_classement <- players$Classement[1]
  
  # 10. Return summary info
  list(
    indice = indice,
    n_players = n_players,
    first_classement = first_classement,
    players_file = rds_file,
    html_file = html_file
  )
}

get_club_info("N051")

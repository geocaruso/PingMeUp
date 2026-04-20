#get_club_ranking.R
#Returns dataframe with all players as of 
#https://data.aftt.be/ranking/clubs.php
#messieurs only March 2026

library(httr)
library(rvest)
library(stringr)
library(jsonlite)

get_club_ranking <- function(indice) {
  
  # 1. POST to load the page with the selected club
  res <- POST(
    url   = "https://data.aftt.be/ranking/clubs.php",
    body  = list(indice = indice),
    encode = "form"
  )
  
  html <- read_html(content(res, "text", encoding = "UTF-8"))
  
  # 2. Extract all <script> blocks
  nodes <- rvest::html_elements(html, "script")
  scripts <- rvest::html_text(nodes)
  
  # 3. Take the script that contains the Messieurs rows definition
  target <- scripts[str_detect(scripts, "rows: category === \"Messieurs\"")]
  if (length(target) == 0) stop("No script with Messieurs rows found")
  target <- target[1]
  
  # 4. Cut from "rows: category" onward
  start <- regexpr("rows: category === \"Messieurs\"", target, fixed = TRUE)
  subtxt <- substring(target, start)
  
  # 5. Find first "[" after that
  open_pos <- regexpr("[", subtxt, fixed = TRUE)
  
  # 6. Find the end of the Messieurs array: the "}] :"
  end_marker <- regexpr("}] :", subtxt, fixed = TRUE)
  if (end_marker == -1) stop("End of Messieurs array not found")
  close_pos <- end_marker + 1  # position of the second ']'
  
  # 7. Extract the JSON array text, including [ and ]
  json_text <- substring(subtxt, open_pos, close_pos)
  
  # 8. Parse JSON
  df <- fromJSON(json_text)
  
  df
}

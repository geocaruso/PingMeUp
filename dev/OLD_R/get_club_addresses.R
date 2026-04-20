#get_club_addresses.R

# R script to get Belgian table tennis clubs addresses from aftt annuaire
# G Caruso

# Source: https://data.aftt.be/annuaire/membres.php
# Loops through the list of clubs (indices) stored in
# Clubs_indices.rds, see GetListofClubs.R,

# Around 500 (clubs) access to server aftt, use a delay between 1 and 2 seconds
# to avoid being a nuisance to their website

# Retrieves clubs adresses, plus number of teams Messieurs and Dames
# Also saves each html page in html folder

# Function----

get_addresses <- function(idx_vec,
                          min_delay_sec = 1,
                          max_delay_sec = 2) {
  
  # Internal function for one address
  get_one_address <- function(idx) {
    res <- httr::POST(url = "https://data.aftt.be/annuaire/membres.php",
                      body = list(indice = idx),
                      encode = "form")
    
  # Extract raw HTML as text
    html_raw <- httr::content(res, "text", encoding = "UTF-8")

  #Save raw HTML text to disk #in case other info needed
    html_file <- file.path("html", paste0(idx, ".html"))
    writeLines(html_raw, html_file)
    
    page <- rvest::read_html(html_raw)
    
    # Extract the address after "Adresse :"
    page_text <- rvest::html_text(page)
    
    address <- stringr::str_match(page_text, "Adresse\\s*:\\s*(.*)")[, 2]
    
    # Also extracts the number of Messieurs and Dames teams"
    messieurs <- stringr::str_match(page_text, "Messieurs\\s*:\\s*(.*)")[, 2]
    dames <- stringr::str_match(page_text, "Dames\\s*:\\s*(.*)")[, 2]
    
    data.frame(indice = idx, addresse = address,
               equipes_messieurs=messieurs, equipes_dames=dames
               )
  }
  
  # Apply function to entire vector of indices
  results_lst <- lapply(idx_vec, function(i) {
    Sys.sleep(runif(1, min_delay_sec, max_delay_sec))
    get_one_address(i)
  })
  
  results <- do.call(rbind, results_lst)
  
  results
}

# Example / Application ----

club_list<-readRDS("rds/Clubs_indices.rds")
myindices<-sample(club_list$indice,5) #only 5 clubs randomly for testing
#myindices<-club_list$indice #FOR ALL

# BE CAREFUL with choosing all !
# 1 or 2SECS PER CLUB x 500 => 15 minutes to avoid
# too MANY REQUESTS ON AFTT SERVER in a small amount of time!

Clubs_addresses<-get_addresses(myindices)

saveRDS(Clubs_addresses,"rds/Clubs_addresses.rds")
write.csv(Clubs_addresses,"rds/Clubs_addresses.csv")



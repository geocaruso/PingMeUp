#' Build and archive current registry of clubs
#'
#' (Runtime: ~15 minutes, >500 clubs)
#' Creates a new club registry snapshot from AFTT annuaire (https://data.aftt.be/annuaire/membres.php). The process involves
#' - fetching club indices, names, and provinces (one web page)
#' - scraping postal addresses and team counts from every club's page. 
#'- Merging into a consolidated club registry
#'
#' Stores the club registry in two objects:
#'   - `club_registry`: the latest snapshot (data.frame)
#'   - `club_registry_archive`: a named list of past snapshots ("YYYY_MM")
#'
#' Both objects are saved in `data/` as `.rda` files.
#'
#' @param min_delay_sec Minimum delay between requests in seconds.
#' @param max_delay_sec Maximum delay between requests in seconds.
#'
#' @return Save files and invisibly returns a list with `club_registry` and `club_registry_archive`
#' 
#' @seealso \code{\link{get.club.list}}
#' 
#' @export
build.club.registry <- function(min_delay_sec = 1,
                                 max_delay_sec = 2) {
  
  # timestamp
  today <- Sys.Date()
  year  <- as.integer(format(today, "%Y"))
  month <- as.integer(format(today, "%m"))
  tag   <- sprintf("%04d_%02d", year, month)
  
  # Load existing archive if present
  archive_file <- "data/club_registry_archive.rda"
  if (file.exists(archive_file)) {
    load(archive_file)  # loads club_registry_archive
  } else {
    club_registry_archive <- list()
  }
  
  # Load previous latest snapshot if present
  latest_file <- "data/club_registry.rda"
  if (file.exists(latest_file)) {
    load(latest_file)  # loads club_registry
    # Move previous snapshot to archive
    prev_tag <- sprintf("%04d_%02d",
                        attr(club_registry, "year"),
                        attr(club_registry, "month"))
    club_registry_archive[[prev_tag]] <- club_registry
  }
  
  message("Step 1: Fetching indices, club names and provinces")
  club_base <- get.club.list()
  idx_vec <- club_base$indice
  
  message("Step 2: Fetching addresses (this may take ~15 mins)...")
  
  html_list <- vector("list", length(idx_vec))
  names(html_list) <- idx_vec
  
  get_one <- function(idx) {
    res <- httr::POST(
      url = "https://data.aftt.be/annuaire/membres.php",
      body = list(indice = idx),
      encode = "form"
    )
    
    html_raw <- httr::content(res, "text", encoding = "UTF-8")
    html_list[[idx]] <<- html_raw
    
    page <- rvest::read_html(html_raw)
    txt  <- rvest::html_text(rvest::html_elements(page, "body"))
    
    address   <- stringr::str_match(txt, "Adresse\\s*:\\s*(.*)")[, 2]
    messieurs <- stringr::str_match(txt, "Messieurs\\s*:\\s*(.*)")[, 2]
    dames     <- stringr::str_match(txt, "Dames\\s*:\\s*(.*)")[, 2]
    
    data.frame(
      indice = idx,
      address = address,
      equipes_messieurs = messieurs,
      equipes_dames = dames,
      stringsAsFactors = FALSE
    )
  }
  
  df_list <- lapply(seq_along(idx_vec), function(k) {
    idx <- idx_vec[k]
    message(sprintf("Fetching %d / %d (%s)", k, length(idx_vec), idx))
    Sys.sleep(runif(1, min_delay_sec, max_delay_sec))
    get_one(idx)
  })
  
  addresses <- do.call(rbind, df_list)
  
  message("Step 3: Merging club indices and names with addresses")
  club_registry <- merge(club_base, addresses, by = "indice", all.x = TRUE)
  
  # attach metadata
  #attr(club_registry, "html_raw") <- html_list
  attr(club_registry, "year")     <- year
  attr(club_registry, "month")    <- month
  
  # ensure data/ exists
  if (!dir.exists("data"))
    dir.create("data")
  
  # Save latest snapshot
  message("Step 4: Saving club_registry to data folder")
  save(club_registry, file = "data/club_registry.rda")
  
  # Save archive
  save(club_registry_archive, file = "data/club_registry_archive.rda")
  
  invisible(list(
    club_registry = club_registry,
    club_registry_archive = club_registry_archive
  ))
}

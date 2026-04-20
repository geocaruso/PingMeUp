#' Build and archive the full Messieurs players registry 
#' 
#' Retrieves (very gently) the Messieurs player list for every club in current `club_registry`. Iterate through provinces then clubs. Enriches the data with classement letters/numebrs separation and within-province ranking.
#' Stores the result in:
#'   - `players_m`: latest snapshot (data frame)
#'   - `players_m_archive`: named list of past snapshots ("YYYY_MM")
#'
#' @param min_delay_sec Minimum delay between club requests.
#' @param max_delay_sec Maximum delay between club requests.
#'
#' @return Invisibly returns a list with `players_m` and `players_m_archive`.
#' @export
build.players.registry.m <- function(min_delay_sec = 1,
                                     max_delay_sec = 3) {
  
  # timestamp
  today <- Sys.Date()
  year  <- as.integer(format(today, "%Y"))
  month <- as.integer(format(today, "%m"))
  tag   <- sprintf("%04d_%02d", year, month)
  
  # Load club registry (for indices + provinces only)
  data(club_registry, envir = environment())
  provinces <- unique(club_registry$province)
  
  # Load existing archive if present
  archive_file <- "data/players_m_archive.rda"
  if (file.exists(archive_file)) {
    load(archive_file)  # loads players_m_archive
  } else {
    players_m_archive <- list()
  }
  
  # Load previous latest snapshot if present
  latest_file <- "data/players_m.rda"
  if (file.exists(latest_file)) {
    load(latest_file)  # loads players_m
    prev_tag <- sprintf("%04d_%02d",
                        attr(players_m, "year"),
                        attr(players_m, "month"))
    players_m_archive[[prev_tag]] <- players_m
  }
  
  # Accumulator for all provinces
  prov_results <- list()
  
  message("Building Messieurs players registry per province...")
  
  for (prov in provinces) {
    
    message("Province: ", prov)
    
    # clubs in this province
    sub <- subset(club_registry, province == prov)
    idx_vec <- sub$indice
    
    # accumulator for clubs in this province
    club_list <- vector("list", length(idx_vec))
    names(club_list) <- idx_vec
    
    for (i in seq_along(idx_vec)) {
      idx <- idx_vec[i]
      message(sprintf("  Club %s (%d of %d)", idx, i, length(idx_vec)))
      
      Sys.sleep(runif(1, min_delay_sec, max_delay_sec))
      
      club_list[[i]] <- try({
        df <- get.club.player.list.m(idx)
        df$club <- idx
        df$prov <- prov
        df
      }, silent = TRUE)
    }
    
    # keep only successful clubs
    ok <- vapply(club_list, is.data.frame, logical(1))
    players_prov <- do.call(rbind, club_list[ok])
    
    if (nrow(players_prov) == 0) {
      message("  -> No valid clubs in province ", prov)
      next
    }
    
    # ---- CLEANING & ATTRIBUTE ENRICHMENT ----
    
    # classement letter
    players_prov$classement_lettre <- substring(players_prov$classement, 1, 1)
    players_prov$classement_lettre[
      players_prov$classement_lettre == "N"
    ] <- "NC"
    
    players_prov$classement_lettre <- factor(
      players_prov$classement_lettre,
      levels = c("A", "B", "C", "D", "E", "NC")
    )
    
    # classement number
    players_prov$classement_chiffre <- "99"
    mask <- players_prov$classement_lettre %in% c("B", "C", "D", "E")
    players_prov$classement_chiffre[mask] <-
      substring(players_prov$classement[mask], 2, 2)
    
    players_prov$classement_chiffre <- factor(
      players_prov$classement_chiffre,
      levels = c("0", "2", "4", "6", "99")
    )
    
    # provincial ranking (active only)
    active <- players_prov$position_bis != "Inactive"
    players_prov$position_bis_p <- NA_integer_
    players_prov$position_bis_p[active] <-
      rank(-players_prov$points[active], ties.method = "min")
    
    prov_results[[prov]] <- players_prov
  }
  
  # bind all provinces
  players_m <- do.call(rbind, prov_results)
  
  # metadata
  attr(players_m, "year")      <- year
  attr(players_m, "month")     <- month
  attr(players_m, "retrieved") <- Sys.time()
  
  # ensure data/ exists
  if (!dir.exists("data"))
    dir.create("data")
  
  # save latest snapshot (with stronger compression)
  save(players_m, file = "data/players_m.rda", compress = "xz")
  
  # save archive
  save(players_m_archive, file = "data/players_m_archive.rda", compress = "xz")
  
  invisible(list(
    players_m = players_m,
    players_m_archive = players_m_archive
  ))
}

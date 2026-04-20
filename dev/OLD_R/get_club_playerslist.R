#get_club_playerslist.R
#Applies get_club_ranking, i.e retrieving players list and points for any given
#club, for all clubs in a province.
#This loop request the opening of a specifc club in data aftt.
#Use with care!
#Result is a idx_playerslist.rds file for each club with indice idx

source("get_club_ranking.R")
club_list<-readRDS("rds/Clubs_indices.rds")

prov<-"BBW" #H N Lx L BBW done for March 2026
sub_club_df<-club_list[club_list$province==prov,] 
nrow(sub_club_df)
list_of_indices<-sub_club_df[1:nrow(sub_club_df),"indice"]
#N101, N140, N151 N215 throw erros : Club no longer exists
#other provinces missings not reported (Try added)

for (i in seq_along(list_of_indices)) {
  try({
  idx <- list_of_indices[i]
  cat("Fetching club", idx, "(", i, "of", length(list_of_indices), ")\n")
  
  # Fetch info
  mydf <- get_club_ranking(idx)
  saveRDS(mydf,paste0("rds/players_club_list_rds/",idx,"_playerslist.rds"))

  # Very gentle delay
  Sys.sleep(runif(1, 5, 20)) #Between 5 and 25 secs
  })
  }


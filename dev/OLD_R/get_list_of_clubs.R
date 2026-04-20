#get.clubs.list.R

# R script to obtain list of all table tennis club codes (indices)
# G Caruso

# Note, this script only reads once the aftt website. No impact on their server
# In fact, the response to selecting any club actually on source page
# includes the list of all clubs

# Source: https://data.aftt.be/annuaire/membres.php

library(rvest)

url <- "https://data.aftt.be/annuaire/membres.php"

page <- read_html(url)

# Extract all <option> nodes inside the <select name="indice">
opts <- html_elements(page, "select[name='indice'] option")

# Extract values and labels
indices <- html_attr(opts, "value")
labels  <- html_text(opts, trim = TRUE)

# Remove those not corresponding to a club indice
keep <- grepl("[0-9]{3}$", indices) &  # code must finish with 3 numbers
                                       # otherwise it is province or other
  !grepl("000$", indices) #indicates province

indices <- indices[keep]
labels  <- labels[keep]


# Assemble into data.frame
club_list <- data.frame(
  indice = indices,
  label  = labels,
  stringsAsFactors = FALSE
)

nrow(club_list)

# Add province from indice (removing numbers from indice)
club_list[,"province"] <- gsub("[0-9]+", "", club_list[,"indice"])

# Save to file

saveRDS(club_list, "rds/Clubs_indices.rds")


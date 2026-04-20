#geocoding_addresses.R
# Geocode adresses

library(httr2)
library(jsonlite)

# Input ----
Clubs_addresses<-readRDS("rds/Clubs_addresses.rds")

# Geocoding (Around 10 minutes!) ----

## Method 1 using nominatim osm ----
# CONCLUSION: 78 cases not identified this way!

# geo0 <- tidygeocoder::geocode( .tbl = Clubs_addresses,
#                               address = addresse_clean,
#                               method = "osm", lat = "lat", long = "lon",)

## Method 2 direct search on OSM nominatin endpoint ----
# CONCLUSION: 73 cases not identified this way! (i.e about same but no dependency to tidygeocoder)

# 2.1 Function to send one address to the Nominatim "search" endpoint
geocode_osm <- function(address) {
  # #Nominatim search endpoint url
  url <- "https://nominatim.openstreetmap.org/search" 
  
  # Build the request object
  req <- request(url) #empty request
  req <- req_url_query(
    req,
    q = address, #address string to search
    format = "json", #output format
    limit = 1, #return only the best match
    addressdetails = 0 #(we don't need the full address breakdown)
  )
  req <- req_user_agent(req, "Geoffrey R geocoder") #User-Agent header (required by Nominatim)
 
  # Get response and parse
  resp <- req_perform(req) #Send request to server 
  json <- resp_body_json(resp) # Parse the JSON body of the response
  
  if (length(json) == 0) { # If no result output NA
    return(data.frame(lat = NA_real_, lon = NA_real_))
  }
  
  # Extract latitude and longitude from first result and make a df
  lat <- as.numeric(json[[1]]$lat)
  lon <- as.numeric(json[[1]]$lon)

  data.frame(lat = lat, lon = lon)
}

# 2.2. Applies to each addresses with a 1-second delay
geo0 <- Clubs_addresses   # work on geo0, keep original Clubs_addresses intact

# Wrapper function
geocode_with_delay <- function(addr) {
  cat("Geocoding", i, "of", nrow(addr), "\n") #
  Sys.sleep(1)                 # Nominatim etiquette
  geocode_osm(addr)            # returns data.frame(lat, lon)
}

#Runs and assemble df
# BEWARE around 15-20 MINUTES!
results_list <- lapply(geo0$addresse, geocode_with_delay)

# assemble
results_df <- do.call(rbind, results_list)
geo0$lat <- results_df$lat
geo0$lon <- results_df$lon

# Cross Checking
failed_geoding <- is.na(geo0$lat) & is.na(geo0$lon) #  those without a lat lon
geo<-geo0[!failed_geoding & !is.na(geo0$addresse) ,] # only those with lat lon (and an adress.. there is 1 case)
cat(paste(nrow(geo))," out of", nrow(geo0))
# 440  out of 514 

# Convert to sf----
# (WGS84)
geo_sf <- sf::st_as_sf(geo, coords = c("lon", "lat"), crs = 4326 )
geo_lambert <- sf::st_transform(geo_sf, 31370) #for Lambert belge 

#save
saveRDS(geo_lambert,"rds/Clubs_sf_pt.rds")
sf::st_write(geo_lambert,"rds/Clubs_sf_pt.gpkg")


## Method 3 prompt Claude AI----

# I believe Claude uses google api after cleaning addresses.
# See raw results in get_club_coords_ai.txt
# and compiled csv in "rds/Clubs_coordsWGS84_ai.csv"

Clubs_coordsWGS84_ai0<-read.csv("rds/Clubs_coordsWGS84_ai.csv")

#Cross-checking
failed_geoding_ai <- is.na(Clubs_coordsWGS84_ai0$latitude) & is.na(Clubs_coordsWGS84_ai0$longitude) #  those without a lat lon
Clubs_coordsWGS84_ai<-Clubs_coordsWGS84_ai0[!failed_geoding_ai & !is.na(Clubs_coordsWGS84_ai0$adresse_clean),] # only those with lat lon (and an adress.. there is 1 case)
cat(paste(nrow(Clubs_coordsWGS84_ai))," out of", nrow(Clubs_coordsWGS84_ai0))
#513  out of 514

# Convert to sf----
# (WGS84)
geo_sf_ai <- sf::st_as_sf(Clubs_coordsWGS84_ai, coords = c("longitude", "latitude"), crs = 4326 )
geo_lambert_ai <- sf::st_transform(geo_sf_ai, 31370) #for Lambert belge 

#save
saveRDS(geo_lambert_ai,"rds/Clubs_sf_pt_ai.rds")
sf::st_write(geo_lambert_ai,"rds/Clubs_sf_pt_ai.gpkg")

# Mapping for cross-checking
Clubs_sf_pt <- readRDS("rds/Clubs_sf_pt.rds")
Clubs_sf_pt_ai <- readRDS("rds/Clubs_sf_pt_ai.rds")
#adds XY in dataframe
Clubs_sf_pt[,c("X_OSM","Y_OSM")]<-sf::st_coordinates(Clubs_sf_pt)
Clubs_sf_pt_ai[,c("X_ai","Y_ai")]<-sf::st_coordinates(Clubs_sf_pt_ai)

## Simple map to check ai geocoding agaisnt not ai
ggplot()+
  geom_sf(data=Provinces_sf)+
  geom_sf(data=Clubs_sf_pt_ai,col="blue")+
  geom_sf(data=Clubs_sf_pt,col="grey10")+
  theme_bw()

#merge the complete (non-sf) data and compare locations
m<-merge(Clubs_sf_pt_ai,sf::st_drop_geometry(Clubs_sf_pt),
         by="indice", all.x=TRUE)
m$dist_m<-sqrt((m$X_ai-m$X_OSM)^2 + (m$Y_ai-m$Y_OSM)^2)
summary(m$dist_m)
View(m) #Largest differences 16km, 8km, 2.5km

ggplot()+
  geom_sf(data=Provinces_sf)+
  geom_sf(data=Clubs_sf_pt_ai,col="blue")+
  geom_sf(data=Clubs_sf_pt,col="grey10")+
  geom_segment(data=m,aes(x = X_OSM, y = Y_OSM, xend = X_ai, yend=Y_ai), col="red")+
  theme_bw()

#Club indices where distance between the 2 coords system is over 1km
sf::st_drop_geometry(m[m$dist_m>1000 & !is.na(m$dist_m),"indice"])

#Visual check on google maps based on address and WGS84 coords
# indice
# 90    H182 > pick ai
# 92    H202 > pick ai
# 118   H314 > pick ai
# 120   H333 > pick ai
# 172   L043 > pick OSM
# 175   L098 > pick ai
# 193   L230 > pick ai
# 200   L266 > pick ai
# 236   L374 > pick ai
# 281  LK076 > none very good. Best is exactr location 51.092089064426666, 5.529746148688867
# 312  Lx044 > pick ai
# 394   N146 #Andenne allocated rue Rogier Namur by ai > pick OSM
# 429   N223 > pick OSM 
# 432 OVL018 > pick ai
# 452 OVL106 > pick ai

# Given thos observations and the fact geocoding ai has 73 more, use
# ai based geocoding and change the 3 identified above with OSM

Clubs_sf0 <- Clubs_sf_pt_ai
Clubs_sf0[Clubs_sf0$indice %in% c("N146","N223","L043"),"geometry"] <-
  Clubs_sf_pt[Clubs_sf_pt$indice %in% c("N146","N223","L043"),"geometry"]

#Cleaning
# (removing anything that was for geocoding, i.e keep only indice)
# merge with original file where adresses and teams were retrieved
#Note: 513 clubs because one had no address: Lx012 (CTT Messancy, which I understand is closed)
Clubs_sf01<-Clubs_sf0[,"indice"]
Clubs_sf<-merge(Clubs_sf01,
                Clubs_addresses,
                by="indice")

# add/transform variables ----
Clubs_sf$equipes_messieurs <- as.numeric(Clubs_sf$equipes_messieurs)
Clubs_sf$equipes_dames <- as.numeric(Clubs_sf$equipes_dames)
Clubs_sf$equipes <-Clubs_sf$equipes_dames+Clubs_sf$equipes_messieurs

Clubs_sf$province <- as.factor(Clubs_sf$province)
Clubs_sf$aftt <- (Clubs_sf$province %in% c("BBW", "H", "L", "Lx", "N"))*1
names(Clubs_sf)[names(Clubs_sf)=="addresse"]<-"adresse" #orthograph correction

#reorder
Clubs_sf<-Clubs_sf[,c("indice","adresse","province","aftt","equipes",
                      "equipes_messieurs","equipes_dames")]

summary(Clubs_sf)

# Save final
saveRDS(Clubs_sf,"rds/Clubs_sf_513.rds")
sf::st_write(Clubs_sf,"rds/Clubs_sf_513.gpkg")

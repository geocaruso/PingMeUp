#maps_clubs.R
# Mapping of clubs with ggplot2
# G Caruso

library(ggplot2)

# input ----

# Main (513 Clubs point sf created from geocoding)
#Clubs_sf_513<-sf::st_read("rds/Clubs_sf_513.gpkg") #same but need to reformat variables
Clubs_sf_513<-readRDS("rds/Clubs_sf_513.rds")

# Additional
Provinces_sf <- sf::st_read("data/provinces.shp")
sf::st_crs(Provinces_sf) <- sf::st_crs(Clubs_sf_513)

# maps ----

## Simple dot map with provinces 
ggplot(data=Clubs_sf_513)+
  geom_sf(aes(col=province))+
  theme_bw()

## Map with proprtional symbol based on number of teams
#(onlywhere available ie aftt)
subdata<-Clubs_sf_513[Clubs_sf_513$aftt==1,]
subprov<-Provinces_sf[Provinces_sf$INS %in% c(4,5,7,8,9,11),]
ggplot(data=subdata)+
  geom_sf(data=subprov, fill="grey10",col="grey90")+
  geom_sf(aes(size=equipes), col="gold")+
  scale_size_area(max_size = 12)+
  theme_void()

ggplot(data=subdata)+
  geom_sf(data=subprov, fill="grey10")+
  geom_sf(aes(size=equipes_messieurs), col="lightblue")+
  scale_size_area(max_size = 10)+
  theme_void()

ggplot(data=subdata)+
  geom_sf(data=subprov, fill="grey10")+
  geom_sf(aes(size=equipes_dames), col="lightgreen")+
  scale_size_area(max_size = 8)+
  theme_void()

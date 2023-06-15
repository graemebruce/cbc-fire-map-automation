library(lubridate) # deal with dates
library(tidyverse)
library(sf)
# https://www.ospo.noaa.gov/Products/land/hms.html
#empty the directory first so we don't collect giant shapefiles
file.remove(file.path("raw_map_data/smoke", dir(path="raw_map_data/smoke")))

yesterday_month = month(Sys.Date()-1) 
yesterday_day = mday(Sys.Date()-1)

yesterday_day <- if_else(yesterday_day < 10, paste0("0",as.character(yesterday_day)), as.character(yesterday_day))

smoke_url <- paste0("https://satepsanone.nesdis.noaa.gov/pub/FIRE/web/HMS/Smoke_Polygons/Shapefile/2023/0",yesterday_month,"/hms_smoke20230",yesterday_month,yesterday_day,".zip")
smoke_temp <- tempfile(fileext = ".zip")
download.file(smoke_url, smoke_temp)
unzip(smoke_temp,exdir = "../raw_map_data/smoke")

smoke_data <- read_sf(paste0("../raw_map_data/smoke/hms_smoke20230",yesterday_month,yesterday_day,".shp")) %>%
  separate(Start, c("start_date", "start_time")) %>%
  separate(End, c("end_date", "end_time"))
smoke_data_east <- smoke_data %>%
  dplyr::filter(Satellite == "GOES-EAST") 

heavy_smoke <- smoke_data_east %>%
  dplyr::filter(Density=="Heavy") %>%
  slice_max(End, n = 1) #This picks the latest observation if there is more than one
sf::st_write(heavy_smoke, dsn = "../clean_map_data/smoke/heavy_smoke.geojson", layer = "../clean_map_data/smoke/heavy_smoke.geojson",delete_dsn = T)

medium_smoke <- smoke_data_east %>%
  dplyr::filter(Density=="Medium") %>%
  slice_max(End, n = 1) #This picks the latest observation if there is more than one
sf::st_write(medium_smoke, dsn = "../clean_map_data/smoke/medium_smoke.geojson", layer = "../clean_map_data/smoke/medium_smoke.geojson",delete_dsn = T)

light_smoke <- smoke_data_east %>%
  dplyr::filter(Density=="Light") %>%
  slice_max(End, n = 1) #This picks the latest observation if there is more than one
sf::st_write(light_smoke, dsn = "../clean_map_data/smoke/light_smoke.geojson", layer = "../clean_map_data/smoke/light_smoke.geojson",delete_dsn = T)

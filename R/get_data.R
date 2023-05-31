library(sf) # simple features packages for handling vector GIS data
library(httr) # generic webservice package
library(tidyverse) # a suite of packages for data wrangling, transformation, plotting
library(ows4R) # interface for OGC web services
library(rmapshaper) # simplify shapefiles
library(lubridate) # deal with dates
library(dplyr)

agencies <- c("ab","sk","ak","bc","nt","pc","on","nb","ns","mb","qc")

########################Locations########################
active_fires_raw <- read.csv("https://cwfis.cfs.nrcan.gc.ca/downloads/activefires/activefires.csv")

for (i in agencies) {
  
  out_of_control_locations <- active_fires_raw %>%
    dplyr::filter(agency == i,
                  stage_of_control ==" OC") 
  write.csv(out_of_control_locations,paste0("clean_map_data/locations/",i,"/out_of_control_locations.csv"))
  # sf::st_write(out_of_control_locations, dsn = "clean_map_data/locations/out_of_control_locations.geojson", layer = "clean_map_data/locations/out_of_control_locations.geojson",delete_dsn = T)
  
  being_held_locations <- active_fires_raw %>%
    dplyr::filter(agency == i,
                  stage_of_control ==" BH")
  write.csv(being_held_locations,paste0("clean_map_data/locations/",i,"/being_held_locations.csv"))
  # sf::st_write(being_held_locations, dsn = "clean_map_data/locations/being_held_locations.geojson", layer = "clean_map_data/locations/being_held_locations.geojson",delete_dsn = T)
  
  print(paste0(i, " complete."))
}

########################Perimeters########################

perimeters_dbf_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.dbf"
download.file(perimeters_dbf_url,"raw_map_data/fire_perims/perimeters.dbf")
perimeters_prj_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.prj"
download.file(perimeters_prj_url,"raw_map_data/fire_perims//perimeters.prj")
perimeters_shp_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.shp"
download.file(perimeters_shp_url,"raw_map_data/fire_perims/perimeters.shp")
perimeters_shx_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.shx"
download.file(perimeters_shx_url,"raw_map_data/fire_perims/perimeters.shx")

fire_perims <- read_sf("raw_map_data/fire_perims/perimeters.shp") %>%
  st_transform(4326)

fire_perims_simple <- ms_simplify(fire_perims, keep = 0.1,
                                  keep_shapes = FALSE)
sf::st_write(fire_perims_simple, dsn = "clean_map_data/fire_perims/fire_perims_simple.geojson", layer = "clean_map_data/fire_perims/fire_perims_simple.geojson",delete_dsn = T)
########################Smoke########################

#empty the directory first so we don't collect giant shapefiles
file.remove(file.path("raw_map_data/smoke", dir(path="raw_map_data/smoke")))

yesterday_month = month(Sys.Date() - 1)
yesterday_day = mday(Sys.Date() - 1)

smoke_url <- paste0("https://satepsanone.nesdis.noaa.gov/pub/FIRE/web/HMS/Smoke_Polygons/Shapefile/2023/0",yesterday_month,"/hms_smoke20230",yesterday_month,yesterday_day,".zip")
smoke_temp <- tempfile(fileext = ".zip")
download.file(smoke_url, smoke_temp)
unzip(smoke_temp,exdir = "raw_map_data/smoke")

smoke_data <- read_sf(paste0("raw_map_data/smoke/hms_smoke20230",yesterday_month,yesterday_day,".shp"))
smoke_data_east <- smoke_data %>%
  dplyr::filter(Satellite == "GOES-EAST") 

heavy_smoke <- smoke_data_east %>%
  dplyr::filter(Density=="Heavy")
# slice_max(End, n = 1) #This picks the latest observation if there is more than one
sf::st_write(heavy_smoke , dsn = "clean_map_data/smoke/heavy_smoke.geojson", layer = "clean_map_data/smoke/heavy_smoke.geojson",delete_dsn = T)

medium_smoke <- smoke_data_east %>%
  dplyr::filter(Density=="Medium") 
sf::st_write(medium_smoke, dsn = "clean_map_data/smoke/medium_smoke.geojson", layer = "clean_map_data/smoke/medium_smoke.geojson",delete_dsn = T)

light_smoke <- smoke_data_east %>%
  dplyr::filter(Density=="Light")
sf::st_write(light_smoke, dsn = "clean_map_data/smoke/light_smoke.geojson", layer = "clean_map_data/smoke/light_smoke.geojson",delete_dsn = T)

########################Danger########################


danger_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/fire_danger/fdr_scribe.zip"

danger_temp <- tempfile(fileext = ".zip")
download.file(danger_url, danger_temp)
unzip(danger_temp,exdir = "raw_map_data/danger")

danger_data <- read_sf("raw_map_data/danger/fdr_scribe.shp") %>%
  st_transform(4326)

extreme_danger_4 <-  danger_data %>%
  dplyr::filter(GRIDCODE == 4)
extreme_danger_4_simple <- ms_simplify(extreme_danger_4 , keep = 0.1,
                                       keep_shapes = FALSE)
sf::st_write(extreme_danger_4_simple, dsn = "clean_map_data/danger/extreme_danger_4_simple.geojson", layer = "clean_map_data/danger/extreme_danger_4_simple.geojson",delete_dsn = T)

very_high_danger_3 <-  danger_data %>%
  dplyr::filter(GRIDCODE == 3)
very_high_danger_3_simple <- ms_simplify(very_high_danger_3 , keep = 0.1,
                                         keep_shapes = FALSE)
sf::st_write(very_high_danger_3_simple, dsn = "clean_map_data/danger/very_high_danger_3_simple.geojson", layer = "clean_map_data/danger/very_high_danger_3_simple.geojson",delete_dsn = T)

high_danger_2 <-  danger_data %>%
  dplyr::filter(GRIDCODE == 2)
high_danger_2_simple <- ms_simplify(high_danger_2,  keep = 0.0001,
                                    keep_shapes = FALSE)
sf::st_write(high_danger_2, dsn = "clean_map_data/danger/high_danger_2_simple.geojson", layer = "clean_map_data/danger/high_danger_2_simple.geojson",delete_dsn = T)

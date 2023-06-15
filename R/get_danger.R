library(tidyverse)
library(sf)
library(rmapshaper)
danger_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/fire_danger/fdr_scribe.zip"

danger_temp <- tempfile(fileext = ".zip")
download.file(danger_url, danger_temp)
unzip(danger_temp,exdir = "../raw_map_data/danger")

danger_data <- read_sf("../raw_map_data/danger/fdr_scribe.shp") %>%
  st_transform(4326)

extreme_danger_4 <-  danger_data %>%
  dplyr::filter(GRIDCODE == 4)
extreme_danger_4_simple <- ms_simplify(extreme_danger_4)
sf::st_write(extreme_danger_4_simple, dsn = "../clean_map_data/danger/extreme_danger_4_simple.geojson", layer = "../clean_map_data/danger/extreme_danger_4_simple.geojson",delete_dsn = T)

very_high_danger_3 <-  danger_data %>%
  dplyr::filter(GRIDCODE == 3)
very_high_danger_3_simple <- ms_simplify(very_high_danger_3)
sf::st_write(very_high_danger_3_simple, dsn = "../clean_map_data/danger/very_high_danger_3_simple.geojson", layer = "../clean_map_data/danger/very_high_danger_3_simple.geojson",delete_dsn = T)

high_danger_2 <-  danger_data %>%
  dplyr::filter(GRIDCODE == 2)
high_danger_2_simple <- ms_simplify(high_danger_2)
sf::st_write(high_danger_2, dsn = "../clean_map_data/danger/high_danger_2_simple.geojson", layer = "../clean_map_data/danger/high_danger_2_simple.geojson",delete_dsn = T)

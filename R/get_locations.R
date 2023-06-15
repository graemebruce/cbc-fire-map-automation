library(tidyverse)
library(dplyr)
library(usethis)
library(devtools)
active_fires_raw <- read.csv("https://cwfis.cfs.nrcan.gc.ca/downloads/activefires/activefires.csv")
devtools::install_github("munichrocker/DatawRappr")
library(DatawRappr)
my_api_key <- Sys.getenv("API_KEY")
Sys.setenv(TZ = "America/Toronto")
updateTime <- format(Sys.time(), "%H:%M:%S")
updateDate <- format(Sys.Date(), format="%B %d, %Y")
updateTime <- format(strptime(updateTime, "%H:%M:%S"), "%I:%M %p")

#Canada
canada_fires <- active_fires_raw %>%
  dplyr::filter(stage_of_control %in% c(" OC"," BH"," UC"))

dw_data_to_chart(
  canada_fires, 
  "D86jR",
  api_key = my_api_key)

dw_edit_chart(
  "D86jR",
  api_key = my_api_key,
  annotate = paste0("Updated on ",updateDate))
dw_publish_chart(
  "D86jR",
  api_key = my_api_key)

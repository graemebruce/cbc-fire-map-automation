library(rvest)
library(lubridate)
library(dplyr)
library(tidyr)
library(DatawRappr)

updateDate <- format(Sys.Date(), format="%B %d, %Y")


#Get past years (only have to do this once)
# Previous_years <- data.frame()
#
# for (year in 2016:2022) {
#   url <- read_html(paste0("https://cwfis.cfs.nrcan.gc.ca/maps/fm3?type=arpt&year=",year)) %>%
#     html_nodes(xpath='//*[contains(concat( " ", @class, " " ), concat( " ", "table-bordered", " " ))]') %>%
#     html_table()
#
#   cumulative_data <- as.data.frame(url[[1]]) %>%
#     dplyr::mutate(`Year-to-date Burned Area (ha)` = gsub(",","",`Year-to-date Burned Area (ha)`),
#                   `Year-to-date Burned Area (ha)` = as.numeric(`Year-to-date Burned Area (ha)`)) %>%
#     dplyr::select(Date,`Year-to-date Burned Area (ha)`)
#
#   Previous_years <- rbind(Previous_years,cumulative_data)
#
# }

# write.csv(Previous_years,"../clean_map_data/cumulative_area_burned/previous_cumulative_area_burned.csv")

previous_cumulative_area_burned <- read.csv("../clean_map_data/cumulative_area_burned/previous_cumulative_area_burned.csv") %>%
  dplyr::rename(cumulative_area_bruned_ha = Year.to.date.Burned.Area..ha.) %>%
  dplyr::select(Date,cumulative_area_bruned_ha)

url <- read_html("https://cwfis.cfs.nrcan.gc.ca/maps/fm3?type=arpt&year=2023") %>%
  html_nodes(xpath='//*[contains(concat( " ", @class, " " ), concat( " ", "table-bordered", " " ))]') %>%
  html_table()

current_cumulative_area_burned <- as.data.frame(url[[1]]) %>%
  dplyr::mutate(`Year-to-date Burned Area (ha)` = gsub(",","",`Year-to-date Burned Area (ha)`),
                `Year-to-date Burned Area (ha)` = as.numeric(`Year-to-date Burned Area (ha)`)) %>%
  dplyr::rename(cumulative_area_bruned_ha = `Year-to-date Burned Area (ha)`) %>%
  dplyr::select(Date,cumulative_area_bruned_ha)


cumulative_area_burned <- rbind(current_cumulative_area_burned,previous_cumulative_area_burned) %>%
  dplyr::mutate(year = lubridate::year(Date),
                month = lubridate::month(Date),
                day = lubridate::day(Date),
                cumulative_area_bruned_ha = as.numeric(cumulative_area_bruned_ha))

cumulative_area_burned_dw <- cumulative_area_burned %>%
  dplyr::mutate(chart_date = as.Date(paste0("1900-0",month,"-",day))) %>%
  dplyr::select(chart_date,year,cumulative_area_bruned_ha) %>%
  pivot_wider(names_from = year, values_from=cumulative_area_bruned_ha)

dw_data_to_chart(cumulative_area_burned_dw, "opSUa")

dw_edit_chart(
  "opSUa",
  api_key = "environment",
  annotate = paste0("Updated on ",updateDate))
dw_publish_chart("opSUa")

library(DatawRappr)
datawrapper_auth(api_key="lKufVLGq4xUfDba6s6Y3Kxpns6FvO2fhbc5eBzbvdqfF98F0LxXfbvGLbY0nZDuX", overwrite = TRUE)
dw_test_key()

# https://docs.airnowapi.org/Data/query
today_date <- as.character(Sys.Date())

today_hour <- format(as.POSIXlt(Sys.time(), tz = "UTC"), format="%H")
today_hour_start <- as.character(as.numeric(today_hour)-2)
today_hour_end <- as.character(as.numeric(today_hour)-1)

airNow_data <- read.csv(paste0("https://www.airnowapi.org/aq/data/?startDate=",today_date,"T",today_hour_start,"&endDate=",today_date,"T",today_hour_end,"&parameters=PM25&BBOX=-135.455627,24.793897,-52.135315,64.295715&dataType=A&format=text/csv&verbose=1&monitorType=0&includerawconcentrations=0&API_KEY=8CE670B6-E82E-41E2-AF21-7D5ACF42C6DA"))
colnames(airNow_data) <- c("latitude","longitude","utc","parameter","concentration","unit","site_name","siteagency","AQS ID","Full AQS ID")

airNow_data <- airNow_data %>%
  dplyr::filter(concentration>=0)

updateDate <- format(Sys.Date(), format="%B %d, %Y")


dw_data_to_chart(airNow_data, "7NZ3P")

dw_edit_chart(
  "7NZ3P",
  api_key = "environment",
  annotate = paste0("Updated on ",updateDate))
dw_publish_chart("7NZ3P")



cities = c(
  "s0000141", # Vancouver
  "s0000775", # Victoria
  "s0000047", # Calgary
  "s0000045", # Edmonton
    "s0000583", # Charlottetown
    "s0000250", # Fredericton
    "s0000318", # Halifax
    "s0000549", # Hamilton
    "s0000394", # Iqaluit
    "s0000635", # Montreal
    "s0000654", # Moncton
    "s0000430", # Ottawa (Kanata - Orléans)
    "s0000620", # Québec
    "s0000788", # Regina
    "s0000687", # Saint John
    "s0000797", # Saskatoon
    "s0000280", # St. John's
    "s0000458", # Toronto
    "s0000785", # Toronto Island
    "s0000825", # Whitehorse
    "s0000193", # Winnipeg
    "s0000366", # Yellowknife
    "s0000573", # Kitchener-Waterloo
    "s0000549", # Hamilton
    "s0000658", # Brampton
    "s0000411", # Thunder Bay
    "s0000646", # Windsor
    "s0000680", # Sudbury
    "s0000326", # London,
    "s0000746", # Fort St. John
    "s0000592", #Kelowna
  "s0000146" # Prince George
                           
)

air_quality_master <- data.frame()
for (city in cities) {
  current_conditions_url <- jsonlite::fromJSON(paste0("https://canopy.cbc.ca/live/climate-dashboard/api/v1.3.13/",city,"/currentConditions"))
  
  air_quality  <- purrr::pluck(current_conditions_url,"airQuality",1)
  station <- city
  df <- data.frame(station, air_quality)
  print(df)
  air_quality_master<- rbind(air_quality_master,df)
}

air_quality_master <- air_quality_master %>%
dplyr::mutate(city = recode(station, 
                            "s0000141" =  "Vancouver",
                            "s0000775" =  "Victoria",
                            "s0000047" =  "Calgary",
                            "s0000045" =  "Edmonton",
                            "s0000583" =  "Charlottetown",
                            "s0000250" =  "Fredericton",
                            "s0000318" =  "Halifax",
                            "s0000549" =  "Hamilton",
                            "s0000394" =  "Iqaluit",
                            "s0000635" =  "Montreal",
                            "s0000654" =  "Moncton",
                            "s0000430" =  "Ottawa (Kanata - Orléans)",
                            "s0000620" =  "Québec",
                            "s0000788" =  "Regina",
                            "s0000687" =  "Saint John",
                            "s0000797" =  "Saskatoon",
                            "s0000280" =  "St. John's",
                            "s0000458" =  "Toronto",
                            "s0000785" =  "Toronto Island",
                            "s0000825" = " Whitehorse",
                            "s0000193" =  "Winnipeg",
                            "s0000366" =  "Yellowknife",
                            "s0000573" =  "Kitchener-Waterloo",
                            "s0000549" =  "Hamilton",
                            "s0000658" =  "Brampton",
                            "s0000411" =  "Thunder Bay",
                            "s0000646" =  "Windsor",
                            "s0000680" =  "Sudbury",
                            "s0000326" = "London",
                            "s0000746"= "Fort St. John",
                            "s0000592"= "Kelowna",
                            "s0000146" = "Prince George"
)) %>%
  dplyr::select(city,air_quality) %>%
  dplyr::arrange(desc(air_quality))



dw_data_to_chart(air_quality_master, "nA2Oz")

dw_edit_chart(
  "nA2Oz",
  api_key = "environment",
  annotate = paste0("Updated on ",updateDate))
dw_publish_chart("nA2Oz")




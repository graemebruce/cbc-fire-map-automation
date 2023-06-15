library(sf)
library(rmapshaper) # simplify shapefiles
# perimeter_url <- "https://cwfis.cfs.nrcan.gc.ca/geoserver/public/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=public%3Am3_polygons_current&maxFeatures=5000&outputFormat=SHAPE-ZIP"
# perimeter_temp <- tempfile(fileext = ".zip")
# download.file(perimeter_url, perimeter_temp)
# unzip(perimeter_temp,exdir = "raw_map_data/fire_perims")

perimeters_dbf_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.dbf"
download.file(perimeters_dbf_url,"../raw_map_data/fire_perims/perimeters.dbf")
perimeters_prj_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.prj"
download.file(perimeters_prj_url,"../raw_map_data/fire_perims//perimeters.prj")
perimeters_shp_url <- "../https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.shp"
download.file(perimeters_shp_url,"../raw_map_data/fire_perims/perimeters.shp")
perimeters_shx_url <- "https://cwfis.cfs.nrcan.gc.ca/downloads/hotspots/perimeters.shx"
download.file(perimeters_shx_url,"../raw_map_data/fire_perims/perimeters.shx")

fire_perims <- read_sf("../raw_map_data/fire_perims/m3_polygons_current.shp") %>%
st_transform(4326)

fire_perims_simple <- ms_simplify(fire_perims)

sf::st_write(fire_perims_simple, dsn = "../clean_map_data/fire_perims/fire_perims_simple.geojson", layer = "../clean_map_data/fire_perims/fire_perims_simple.geojson",delete_dsn = T)

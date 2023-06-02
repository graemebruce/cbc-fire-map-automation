import geopandas
import pandas as pd
import datawrappergraphics as dw



# These are published DW maps
#change map id for testing




###Locations


map_id_locs = "Xg35z"  #id

dataOC = geopandas.read_file("../clean_map_data/locations/qc/out_of_control_locations.geojson")
dataBH = geopandas.read_file("../clean_map_data/locations/qc/being_held_locations.geojson")


dataOC["type"] = "point"
dataOC["icon"] = "circle-sm"
dataOC["markerColor"] = ("#c42127")

dataBH["type"] = "point"
dataBH["icon"] = "circle-sm"
dataBH["markerColor"] = ("#ff7f00")

data_locs = pd.concat([dataOC,dataBH])




map = (dw.Map(map_id_locs)
            .data(data_locs, append="./markers/qc/qc-location-m.json")
            .footer(source="Natural Resources Canada", byline ="(Graeme Bruce, Wendy Martinez/CBC)", timestamp= True)      
            .publish()
            )




###Fire_perims


map_id_perims = "dZU5B"   #id



data_perims = geopandas.read_file("../clean_map_data/fire_perims/fire_perims_simple.geojson")




data_perims["stroke"] = "#ff7f00"
data_perims["stroke-width"] = 1
data_perims["fill"] = "#ff7f00"

map = (dw.Map(map_id_perims)
            .data(data_perims, append="./markers/qc/qc-boundaries-m.json")
            .footer(source="Natural Resources Canada", byline ="(Graeme Bruce, Wendy Martinez/CBC)", timestamp= True)      
            .publish()
            )

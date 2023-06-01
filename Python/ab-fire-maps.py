
import geopandas
import pandas as pd
import datawrappergraphics as dw



# These are published DW maps
#change map id for testing




###Locations


map_id_locs = "Dff0Y"  #id

dataOC = geopandas.read_file("../clean_map_data/locations/ab/out_of_control_locations.geojson")
dataBH = geopandas.read_file("../clean_map_data/locations/ab/being_held_locations.geojson")


dataOC["type"] = "point"
dataOC["icon"] = "circle-sm"
dataOC["markerColor"] = ("#c42127")

dataBH["type"] = "point"
dataBH["icon"] = "circle-sm"
dataBH["markerColor"] = ("#ff7f00")

data_locs = pd.concat([dataOC,dataBH])




map = (dw.Map(map_id_locs)
            .data(data_locs, append="./markers/ab/ab-location-m.json")
            .footer(source="Natural Resources Canada,", byline ="Graeme Bruce, Wendy Martinez/CBC", timestamp= True, tz="America/Edmonton" )      
            .publish()
            )




###Fire_perims


map_id_perims = "tpsTE"   #id



data_perims = geopandas.read_file("../clean_map_data/fire_perims/fire_perims_simple.geojson")




data_perims["stroke"] = "#ff7f00"
data_perims["stroke-width"] = 1
data_perims["fill"] = "#ff7f00"

map = (dw.Map(map_id_perims)
            .data(data_perims, append="./markers/ab/ab-boundaries-m.json")
            .footer(source="Natural Resources Canada,", byline ="Graeme Bruce, Wendy Martinez/CBC", timestamp= True, tz="America/Edmonton" )      
            .publish()
            )


###Smoke   


map_id_smoke = "QV3Jh"   #id

heavy = geopandas.read_file("../clean_map_data/smoke/heavy_smoke.geojson")

heavy["fill"] = "#c42127"
heavy["fill-opacity"] = 0.6
heavy["stroke"] = False

med = geopandas.read_file("../clean_map_data/smoke/medium_smoke.geojson")

med["stroke"] = False
med["fill-opacity"] = 0.4
med["fill"] = "#ff7f00"


light = geopandas.read_file("../clean_map_data/smoke/light_smoke.geojson")

light["fill"] = "#f2d59d"
light["stroke"] = False
light["fill-opacity"] = 0.5

data_smoke = pd.concat([heavy, med, light])




map = (dw.Map(map_id_smoke)
            .data(data_smoke, append="./markers/ab/ab-smoke-m.json")
            .footer(source="NOOA,", byline = "Graeme Bruce, Wendy Martinez/CBC", timestamp=True, tz="America/Edmonton", note="Data as of yesterday. ")      
            .publish()
            )





###Danger zone forecast

map_id_danger = "pNxnP"  #id

extreme = geopandas.read_file("../clean_map_data/danger/extreme_danger_4_simple.geojson")

extreme["fill"] = "#c42127"
extreme["fill-opacity"] = 0.9
extreme["stroke"] = False

very_high = geopandas.read_file("../clean_map_data/danger/very_high_danger_3_simple.geojson")

very_high["stroke"] = False
very_high["fill"] = "#ff7f00"
very_high["fill-opacity"] = 0.9



data_danger = pd.concat([extreme, very_high])




map = (dw.Map(map_id_danger)
            .data(data_danger, append="./markers/ab/ab-danger-m.json")
            .footer(source="Natural Resources Canada,", byline ="Graeme Bruce, Wendy Martinez/CBC", timestamp= True, tz="America/Edmonton" )      
            .publish()
            )




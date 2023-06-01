import geopandas
import json
import pandas as pd
import datawrappergraphics as dw
import pytz


# These are published DW maps
#change map id for testing




###Fire Locations


map_id_locs = "IHe9u" #id

dataOC = geopandas.read_file("../clean_map_data/locations/ns/out_of_control_locations.geojson")
dataBH = geopandas.read_file("../clean_map_data/locations/ns/being_held_locations.geojson")



dataOC["type"] = "point"
dataOC["icon"] = "circle-sm"
dataOC["markerColor"] = ("#c42127")

dataBH["type"] = "point"
dataBH["icon"] = "circle-sm"
dataBH["markerColor"] = ("#ff7f00")



data_locs = pd.concat([dataOC,dataBH])




map = (dw.Map(map_id_locs)
            .data(data_locs, append="./markers/ns/locations-m.json")
            .footer(source="Natural Resources Canada", byline = "(CBC)", timestamp= True, tz="America/Halifax" )      
            .publish()
            )


###perims view 1


map_id_perims = "0Fjmx"   #id


data_perims = geopandas.read_file("./clean_map_data/fire_perims/fire_perims_simple.geojson")

data_perims["stroke"] = "#ff7f00"
data_perims["stroke-width"] = 1
data_perims["fill"] = "#ff7f00"
data_perims["fill-opacity"] = 0.6



map = (dw.Map(map_id_perims)
            .data(data_perims, append="./markers/ns/perims-1.json")
            .footer(source=False, byline=False, timestamp=False)      
            .publish()
            )



###perims view 2


map_id_perims = "1Zv0y"     #id


data_perims = geopandas.read_file("./clean_map_data/fire_perims/fire_perims_simple.geojson")

data_perims["stroke"] = "#ff7f00"
data_perims["stroke-width"] = 1
data_perims["fill"] = "#ff7f00"
data_perims["fill-opacity"] = 0.6



map = (dw.Map(map_id_perims)
            .data(data_perims, append="./markers/ns/perims-2.json")
            .footer(source="Natural Resources Canada", byline="(CBC)", timestamp= True, tz="America/Halifax")      
            .publish()
            )




###Smoke


map_id_smoke = "NoDPF"   #id

heavy = geopandas.read_file("./clean_map_data/smoke/heavy_smoke.geojson")

heavy["fill"] = "#c42127"
heavy["fill-opacity"] = 1
heavy["stroke"] = False

med = geopandas.read_file("./clean_map_data/smoke/medium_smoke.geojson")

med["stroke"] = False
med["fill-opacity"] = 0.4
med["fill"] = "#ff7f00"


light = geopandas.read_file("./clean_map_data/smoke/light_smoke.geojson")

light["fill"] = "#f2d59d"
light["stroke"] = False
light["fill-opacity"] = 0.5

data_smoke = pd.concat([heavy, med, light])




map = (dw.Map(map_id_smoke)
            .data(data_smoke, append="./markers/ns/smoke-m.json")
            .footer(source="NOOA", byline = "(CBC)", timestamp=True, tz="America/Halifax", note="Data as of yesterday" )      
            .publish()
            )




####fire danger forecast

#high_danger geojson file corrupted


map_id_danger = "u29Ps"    #id

extreme = geopandas.read_file("./clean_map_data/danger/extreme_danger_4_simple.geojson")

extreme["fill"] = "#c42127"
extreme["fill-opacity"] = 0.9
extreme["stroke"] = False

very_high = geopandas.read_file("./clean_map_data/danger/very_high_danger_3_simple.geojson")

very_high["stroke"] = False
very_high["fill"] = "#ff7f00"
very_high["fill-opacity"] = 0.9


data_danger = pd.concat([extreme,very_high])




map = (dw.Map(map_id_danger)
            .data(data_danger, append="./markers/ns/fd-m.json")
            .footer(source="Natural Resources Canada", byline ="(CBC)", timestamp= True, tz="America/Halifax" )      
            .publish()
            )




import geopandas
import pandas as pd
import datawrappergraphics as dw


###Locations


map_id_locs = "cmzSY"  #id

dataOC = geopandas.read_file("../clean_map_data/locations/canada_oc_100_hec/canada_oc_100_hec.geojson")



dataOC["type"] = "point"
dataOC["icon"] = "circle-sm"
dataOC["markerColor"] = ("#c42127")



#data_locs = pd.concat([dataOC,dataBH])




map = (dw.Map(map_id_locs)
            .data(dataOC, append="./markers/canada/canada-location-m.json")
            .footer(source="Natural Resources Canada", byline ="(Graeme Bruce, Wendy Martinez/CBC)" )      
            .publish()
            )
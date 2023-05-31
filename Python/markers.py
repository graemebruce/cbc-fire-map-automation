import io
import json
import pandas as pd
import datawrappergraphics as dw


#map_id = "IHe9u"


dw = dw.Map("wEe7B").get_markers()
print(json.dumps(dw, sort_keys=True, indent=4))



    

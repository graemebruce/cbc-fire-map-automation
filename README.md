# cbc-fire-map-automation
A script that gets fire location data and maps it.

## Data fetching using R

### Location data
Location data comes from Natural Resources Canada. Data can be found here: https://cwfis.cfs.nrcan.gc.ca/downloads/

Data is split into provinces because locator maps in Datawrapper doesn't allow for more than 100 locations.

### Perimeter data
Data is found in the same place as locations: https://cwfis.cfs.nrcan.gc.ca/downloads/
We're using rmapshaper::ms_simplify to make the files smaller for Datawrapper

### Smoke data
We get snoke data from NOAA in the United States, which can be found here: https://www.ospo.noaa.gov/Products/land/hms-simple.html 
In the code, we filter to include just results from one satellite to avoid duplication (there's GOES-WEST and GOES-EAST, we're using GOES-EAST).
Also note that since we plan to run this once per day in the morning, we take smoke data from the day prior since current data is never available.

### Danger data
Again, this data comes from Natural Resources Canada. We're only concerned about extreme and very high, and high danger levels. Most of the time, Datawrapper can only take extreme and very high due to file size.

## Mapping
Mapping uses a Python library called Datawrappergrahics (https://github.com/dexmcmillan/datawrappergraphics).

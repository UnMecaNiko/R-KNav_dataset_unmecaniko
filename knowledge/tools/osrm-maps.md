# Maps, OSM and OSRM

Robot.com **generated missions** with OSRM (Open Source Routing Machine) over OSM with extra costs (road type, risk, signal). The dataset does **not** include that planned route; only the traveled track (`observation.state.waypoints`).

## What to do in this lab

1. Read the waypoints of every episode in the sample.
2. Use the validated sample interpretation: `[longitude, latitude]`, with US-plausible values in the Parquet. The dataset does not carry a formal CRS tag, so document the WGS84-compatible assumption.
3. Plot it on OpenStreetMap (Folium, Leaflet, GeoJSON). That alone is the sample fleet's map, **without** OSRM.
4. OSRM afterwards: *map matching* (snapping GPS to the sidewalk/street) or comparing "network route vs route actually driven". Software: [Project-OSRM](https://github.com/Project-OSRM/osrm-backend) or a public demo service (do not depend on it for production).

OSRM is not a map: it is a **routing engine** on top of an OSM map. The map looks the same with plain OSM tiles.

The dataset card says the robot position comes from onboard GPS/RTK, with live RTCM corrections, while OSRM generated the pre-routed mission. It does not state that recorded waypoints were post-processed or map-matched with OSRM. Rosetta later synchronized telemetry to the front camera using an as-of-nearest timestamp rule.

Google-Earth-style elevation profiles: discarded ([elevation.md](elevation.md)). If elevation is ever needed: an open DEM (SRTM / COP30).

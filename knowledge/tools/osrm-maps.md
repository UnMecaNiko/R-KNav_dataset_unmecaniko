# Maps, OSM and OSRM

Robot.com **generated missions** with OSRM (Open Source Routing Machine) over OSM with extra costs (road type, risk, signal). The dataset does **not** include that planned route; only the traveled track (`observation.state.waypoints`).

## What to do in this lab

1. Read the waypoints of every episode in the sample.
2. **Validate the units.** The README example (`[1.48, -0.03]`) does not look like longitude/latitude on a US campus (that would be around `-122, 37`). Until the parquet is inspected: either it is WGS84 and the example is wrong, or it is a local frame and OSM does not apply without a projection.
3. If it is WGS84: plot it on OpenStreetMap (Folium, Leaflet, GeoJSON). That alone is the sample fleet's map, **without** OSRM.
4. OSRM afterwards: *map matching* (snapping GPS to the sidewalk/street) or comparing "network route vs route actually driven". Software: [Project-OSRM](https://github.com/Project-OSRM/osrm-backend) or a public demo service (do not depend on it for production).

OSRM is not a map: it is a **routing engine** on top of an OSM map. The map looks the same with plain OSM tiles.

Google-Earth-style elevation profiles: discarded ([elevation.md](elevation.md)). If elevation is ever needed: an open DEM (SRTM / COP30).

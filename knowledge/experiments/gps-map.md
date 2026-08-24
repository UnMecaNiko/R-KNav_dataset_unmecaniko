# Experiment: GPS map (± OSRM)

**Goal.** Plot the trajectories of every episode in the sample on a map and, if the points are WGS84, optionally do map matching with OSRM.

**Dependency.** Confirm what `observation.state.waypoints` actually is ([schema](../dataset/schema.md), [osrm-maps](../tools/osrm-maps.md)).

**What it is not.** A routing engine for the TurtleBot. Spatial analysis only.

**Expected output.** GeoJSON or a Folium HTML in `experiments/gps-map/` (the lightweight HTML may go into git; the mp4 files may not). A note on whether OSRM added anything or plain OSM was enough.

**Status.** Pending code.

# Experiment: GPS map (± OSRM)

**Goal.** Plot the trajectories of every episode in the sample on a map and, if the points are WGS84, optionally do map matching with OSRM.

**Data gate resolved.** The sample Parquet contains US-plausible `[longitude, latitude]` values derived from the GPS/RTK pipeline; no formal CRS tag is present. Evidence and the integrated product plan are in [../../experiments/lerobot-map-visualizer/research-notes.md](../../experiments/lerobot-map-visualizer/research-notes.md).

**What it is not.** A routing engine for the TurtleBot. Spatial analysis only.

**Approved output.** A synchronized map inside the LeRobot Dataset Visualizer's Episodes view, showing cameras, velocity charts, full route, and live marker together. Planning package: [../../experiments/lerobot-map-visualizer/](../../experiments/lerobot-map-visualizer/). A lightweight standalone GeoJSON/Folium proof may support implementation but is not the final product.

**Status.** Product and technical planning approved; implementation pending.

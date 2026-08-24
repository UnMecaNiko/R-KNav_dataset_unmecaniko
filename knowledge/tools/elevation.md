# Elevation / Google Earth — discarded

Idea raised: cross R-KNav's GPS with *elevation profiles* from Google Earth.

**Not done in this lab** (decision 2026-08-23).

- Google Earth / Earth Pro: free app for personal use. Manual profile over a KML. No serious API; the Maps/Earth terms do not allow bulk terrain extraction.
- Google Maps Platform Elevation API: a paid product requiring a billing account. The ToS forbid bulk elevation downloads, building a DEM, and using Maps content to train models. The monthly Maps credit expired in February 2025.
- A pipeline over all episodes needs an **open DEM** (SRTM, Copernicus COP30, [Open Topo Data](https://www.opentopodata.org/)), not Google.

If elevation vs distance is ever needed: SRTM/COP30, cited, ~30 m resolution (good for campus hills, not for a curb). Until then, there is no elevation experiment in the roadmap.

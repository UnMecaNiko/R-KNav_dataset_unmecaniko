# Experimento: mapa GPS (± OSRM)

**Objetivo.** Pintar las trayectorias de todos los episodios del sample sobre un mapa y, si los puntos son WGS84, opcionalmente hacer map matching con OSRM.

**Dependencia.** Confirmar qué son `observation.state.waypoints` ([schema](../dataset/schema.md), [osrm-maps](../tools/osrm-maps.md)).

**No es.** Un routing engine para el TurtleBot. Solo análisis espacial.

**Salida esperada.** GeoJSON o HTML Folium en `experiments/gps-map/` (el HTML ligero sí puede ir a git; no los mp4). Nota de si OSRM aportó algo o si con OSM basta.

**Estado.** Pendiente de código.

# Mapas, OSM y OSRM

Robot.com **generó misiones** con OSRM (Open Source Routing Machine) sobre OSM con costes extra (tipo de vía, riesgo, señal). El dataset **no** incluye esa ruta planeada; solo el trazo recorrido (`observation.state.waypoints`).

## Qué hacer en este lab

1. Leer waypoints de todos los episodios del sample.
2. **Validar unidades.** El ejemplo del README (`[1.48, -0.03]`) no parece longitud/latitud de un campus US (eso sería ~`-122, 37`). Hasta no ver el parquet: o es WGS84 y el ejemplo está mal, o es un frame local y OSM no aplica sin proyección.
3. Si es WGS84: pintar en OpenStreetMap (Folium, Leaflet, geojson). Eso ya es el mapa de la flota del sample, **sin OSRM**.
4. OSRM después: *map matching* (encajar el GPS al andén/calle) o comparar “ruta de red vs ruta hecha”. Software: [Project-OSRM](https://github.com/Project-OSRM/osrm-backend) o un servicio público de demo (no depender de él para producción).

OSRM no es un mapa: es un **motor de rutas** sobre un mapa OSM. El mapa se ve igual con tiles OSM solos.

Perfiles de elevación tipo Google Earth: descartados ([elevation.md](elevation.md)). Si más adelante hace falta cota: DEM abierto (SRTM / COP30).

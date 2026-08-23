# Elevación / Google Earth — descartado

Idea planteada: cruzar el GPS de R-KNav con *elevation profiles* de Google Earth.

**No se hace en este lab** (decisión 2026-08-23).

- Google Earth / Earth Pro: app gratis para uso personal. Perfil a mano sobre un KML. Sin API seria; términos de Maps/Earth no permiten extraer terreno a granel.
- Elevation API de Google Maps Platform: producto de pago, cuenta de billing. Las ToS prohiben bajar elevaciones masivas, armar un DEM, y usar contenido de Maps para entrenar modelos. El crédito mensual de Maps caducó en febrero 2025.
- Para un pipeline sobre todos los episodios hace falta un **DEM abierto** (SRTM, Copernicus COP30, [Open Topo Data](https://www.opentopodata.org/)), no Google.

Si en el futuro se quiere cota vs distancia: SRTM/COP30, citado, resolución ~30 m (sirve para lomas de campus, no para un bordillo). Hasta entonces, no hay experimento de elevación en el roadmap.

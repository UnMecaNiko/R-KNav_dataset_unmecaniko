# Experimento: Nav2 sigue la ruta

**Objetivo.** Convertir el trazo (GPS o waypoints locales) en un `nav_msgs/Path` y que Nav2 lo siga en sim con TurtleBot.

**No es.** Meter las cámaras en Nav2. Nav2 navega con mapa/costmap/odom. El vídeo queda para el hilo LeRobot.

**Dependencia.** Experimento de mapa (frame local, unidades). Algo de replay TurtleBot para tener sim lista.

**Salida.** `experiments/nav2-path/` launch + nota de qué tan bien sigue la polilínea.

**Estado.** Pendiente; después de GPS + TurtleBot.

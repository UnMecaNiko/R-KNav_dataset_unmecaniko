# Roadmap de experimentos

Orden acordado (sesión 2026-08-23). Cada ítem tiene ficha. El código, cuando exista, va en `experiments/<slug>/`.

| # | Experimento | Capa | Estado |
|---|---|---|---|
| 0 | Validar `waypoints` (¿WGS84?) | datos | pendiente |
| 1 | Mapa de episodios ± OSRM | análisis | pendiente |
| 2 | Dead reckoning \(v,\omega\) vs GPS | análisis | pendiente |
| 3 | Replay `/cmd_vel` en TurtleBot + RViz | ROS 2 | pendiente |
| 4 | Nav2 siguiendo la ruta (no el vídeo) | ROS 2 | pendiente |
| 5 | Policy sobre cámaras (LeRobot) | aprendizaje | más adelante |
| 6 | Policy → robot (Rosetta u otro bridge) | cierre de loop | mucho más adelante |
| — | Isaac Sim rover | NVIDIA | opcional, no bloquea 1–4 |
| — | Elevación Google Earth | — | **descartado** |

0 es puerta de 1 y 2. 3 no requiere mapa realista. 4 requiere 1 (ruta). 5 no bloquea 1–4.

No abrir un notebook que copie el visualizador (jerky, histogramas). El Space ya lo hace.

## Criterio de “hecho”

Un experimento está hecho cuando hay carpeta en `experiments/`, README que enlaza esta ficha, y un resultado reproducible (script + figura o bag/sim demo) **sin** subir el dataset.

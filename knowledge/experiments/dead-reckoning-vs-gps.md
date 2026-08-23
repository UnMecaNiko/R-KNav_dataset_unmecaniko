# Experimento: dead reckoning vs GPS

**Objetivo.** Integrar velocidades a pose 2D y ver el drift respecto al trazo GPS (o al waypoint, si no es WGS84: respecto al propio waypoint integrado vs comando).

Hay dos twists:

- `action` — comando
- `observation.state` — odometría medida  

Integrar ambos a 10 fps (uniciclo: \(\dot x = v\cos\theta\), \(\dot y = v\sin\theta\), \(\dot\theta = \omega\)). Tres curvas: GPS/waypoints, odom integrada, comandos integrados.

**Por qué.** Explica tirones, resbalón, y qué tan fiel es el `action` al movimiento real. Es el puente conceptual al replay en TurtleBot (lazo abierto = la curva de comandos).

**Salida.** Script + figura (tres trazos). `experiments/dead-reckoning-vs-gps/`.

**Estado.** Pendiente de código.

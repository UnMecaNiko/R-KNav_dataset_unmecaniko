# Tres capas (no mezclar herramientas)

La confusión habitual: tratar Rosetta, Nav2, el visualizador y el entrenamiento como un solo tubo. No lo son.

```
┌─────────────────────────────────────────────────────────┐
│  ROBOT / SIM                                            │
│  ROS 2 topics: /camera, /odom, /cmd_vel, GPS            │
│  Nav2  = un posible escritor de /cmd_vel                │
│  RViz  = ventana sobre esos topics                      │
│  TurtleBot en Gazebo = otro cuerpo, mismos tipos Twist  │
└───────────────────────────┬─────────────────────────────┘
                            │ rosbag / MCAP
                            ▼
┌─────────────────────────────────────────────────────────┐
│  ROSETTA  (traductor)                                   │
│  YAML contract: topic ROS 2  ↔  feature LeRobot         │
│  Ida:  bag → parquet + mp4                              │
│  Vuelta (opcional): policy → /cmd_vel                   │
│  No “se enchufa a Nav2”. Nav2 es una fuente de Twist.   │
└───────────────────────────┬─────────────────────────────┘
                            ▼
┌─────────────────────────────────────────────────────────┐
│  LEROBOT DATASET                                        │
│  observation.image.*  observation.state  action  task   │
│  Visualizer HF = inspección (incluye métrica “jerky”)   │
└───────────────────────────┬─────────────────────────────┘
                            │  solo si se entrena
                            ▼
┌─────────────────────────────────────────────────────────┐
│  POLICY (ACT, SmolVLA, …)                               │
│  entra vídeo + estado (+ texto) → sale Twist            │
│  Eso sustituye a Nav2 en el volante, no se mete dentro. │
└─────────────────────────────────────────────────────────┘
```

**Nav2 + imágenes:** Nav2 clásico usa mapa, odom, a menudo laser/costmap. No consume los MP4 de R-KNav. Visión+Nav2 es otro stack. En este lab, Nav2 entra **siguiendo una ruta** (GPS pasado a un frame local), no el vídeo.

**Vídeo → modelo:** hilo LeRobot, más tarde. No bloquea GPS, odom ni TurtleBot.

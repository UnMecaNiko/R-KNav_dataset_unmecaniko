# “Jerky” en el visualizador

No es un campo del dataset. Es una etiqueta del [LeRobot Dataset Visualizer](https://huggingface.co/spaces/lerobot/visualize_dataset), pestaña Filtering.

Mira `action` frame a frame (`twist.linear.x`, `twist.angular.z`) y calcula

\[\Delta a_t = a_t - a_{t-1}\]

A 10 fps, eso es el salto de comando en 0,1 s. Si los saltos son grandes, la dimensión sale **jerky** (tirones). Si casi no cambia, **low movement**.

En el sample (inspección 2026-08-23) el Space marcó Overall: Jerky en ambas dimensiones de twist, con episodios más bruscos hacia el 7, 2, 1.

No significa “dataset roto”. En acera es esperable: stick de teleop, frenos de Nav2, peatones. Antes de filtrar, abrir el vídeo del episodio. Integrar \(v,\omega\) vs GPS ([dead-reckoning-vs-gps](../experiments/dead-reckoning-vs-gps.md)) explica parte de esos picos mejor que borrar episodios a ciegas.

El visualizador sugiere *shorter action chunks* y filtrar outliers: receta de brazos de lab. Aquí un rover *tiene* que frenar seco. No copiar esa receta sin mirar el vídeo.

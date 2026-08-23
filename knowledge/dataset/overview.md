# Dataset R-KNav — panorama

Fuente canónica (consultar si algo choca con estas notas):  
[huggingface.co/datasets/robotcom/R-KNav_dataset](https://huggingface.co/datasets/robotcom/R-KNav_dataset)  
Sample: [robotcom/R-KNav_sample](https://huggingface.co/datasets/robotcom/R-KNav_sample)  
Consulta de estas notas: 2026-08-23.

## Qué es

Dataset de **navegación en acera** de la flota **R-Kiwi** de Robot.com (ex Kiwibot). Recogido en ~15 campus/ciudades de EE. UU. durante entregas reales. Pensado para investigación de modelos **visión-lenguaje-acción (VLA)** de navegación, no para un stack clásico de LiDAR.

Cifras que publica Robot.com (LinkedIn / ficha del Hub, 2026; verificar antes de citar en un paper): flota 400+ rovers, 250 000+ millas autónomas, 300 000+ entregas. Corpus total anunciado: **10 000 horas**. El Hub no tiene esas 10k h.

Autores del card: Yaisa Catalina Ramirez Cepeda, Pedro Alejandro Gonzalez, John A. Betancourt (Beta). Contacto 10k h: `airobotics@kiwicampus.com`.

## Tiers

| Recurso | Acceso | Orden de magnitud |
|---|---|---|
| `robotcom/R-KNav_sample` | Público | ~14 episodios, ~18 054 frames, 10 fps, ~30 min, ~2,3 GB |
| `robotcom/R-KNav_dataset` | Gated (formulario + aprobación) | ~300 h, ~1 535 vídeos, ~732 GiB, DOI [10.57967/hf/9276](https://doi.org/10.57967/hf/9276) |
| 10 000 h | Correo a Autonomy | No está en el Hub |

Formato: **LeRobot v3.0** (`codebase_version: v3.0` en el sample). `robot_type: rover`.

## Robot y sensores (lo publicado)

Diferencial. Cuatro RGB (main, left, right, rear), GPS/RTK, IMU. **LiDAR 3D excluido a propósito** (énfasis visión). Acciones: `linear.x` y `angular.z` (comandos de velocidad). Estado de odometría: el mismo par, medido.

Rutas de misión: **OSRM** sobre OSM enriquecido. Captura ROS 2 (rosbags) → recorte a episodios (movimiento, calidad GPS, maniobras) → MCAP + YAML → LeRobot con **Rosetta** adaptado ([iblnkn/rosetta](https://github.com/iblnkn/rosetta)). Sincronización *as-of-nearest* con la cámara frontal. Anonimización: caras y placas.

Modos de conducción: **autónomo (Nav2 custom) y teleoperación**. El Hub **no** trae un campo `teleop` / `autonomous` por frame. `action` es quien tuviera el volante. Las frases tipo *Turn left at the white van…* las genera un **VLM a posteriori**, no eran la consigna de Nav2.

## FoMo

*Foundation Models*, no “fear of missing out”. Entrenar con R-KNav y pedir evaluación en R-Kiwis reales. KPIs: intervenciones/milla y velocidad media vs su stack. Umbral ~50 % para pasar el filtro; cortes semestrales. Premio: infraestructura y robots. Envíos: “coming soon” en robot.com (2026-08-23). El formulario del Hub ya pregunta interés.

Este lab **no** asume inscripción al FoMo. Un policy pequeño sobre el sample no es un envío serio.

## Qué no es

No es nuScenes ni un dataset de auto. No es un bag ROS listo para `ros2 bag play` (hay que reconstruir topics). No incluye el plan interno de Nav2, solo el resultado (`action` / odom / GPS / vídeo).

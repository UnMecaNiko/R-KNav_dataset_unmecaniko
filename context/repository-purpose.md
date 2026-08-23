# Propósito de este repositorio

**Nombre:** `R-KNav_dataset_unmecaniko`  
**Dueño:** [UnMecaNiko](https://github.com/UnMecaNiko)  
**Nacimiento:** 2026-08-23, a partir de una sesión de exploración del dataset y de las herramientas alrededor.

## Qué sí

Un **laboratorio versionado** para:

1. Conservar el contexto del dataset (qué es, cómo se accede, qué hay en cada campo, licencia).
2. Diseñar y luego ejecutar pruebas de análisis y robótica encima de esos datos.
3. Dejar artefactos (notas, scripts, más adelante un replay o un mapa) que demuestren ROS 2 y datos de flota reales, sin fingir un paper de fundación de modelos.

Las pruebas previstas, en orden, están en [../knowledge/experiments/roadmap.md](../knowledge/experiments/roadmap.md). En corto: mapa GPS ± OSRM → odometría vs GPS → TurtleBot en sim con los `twist` → Nav2 siguiendo la ruta (no el video) → mucho más tarde un policy sobre cámaras.

## Qué no

- No es un fork ni un espejo de Hugging Face. El dato se queda en el Hub.
- No es el portafolio web. Si algún día hay un proyecto publicable, se ficha en `projects/` de [unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects) con plantilla en inglés.
- No es una postulación a Robot.com. El lab puede informar conversaciones; las vacantes viven en `planning/career/` del repo principal.
- No es un sitio para entrenar un VLA de 300 h el primer día. El sample son ~14 episodios / ~30 min; sirve para el loop, no para un modelo serio.
- No mezcla Google Earth / Elevation API (descartado: no es abierto para un pipeline; ver [../knowledge/tools/elevation.md](../knowledge/tools/elevation.md)).

## Origen del alcance

La sesión de 2026-08-23 cerró así, en palabras de Nicolas: analizar el dataset de varias formas; pintar GPS con mapas y OSRM; integrar \(v,\omega\) y compararlo con GPS; meter esos comandos en un TurtleBot simulado; aprender Nav2 **sin** forzar las imágenes ahí; dejar video → modelo y Rosetta para cuando toque esa capa.

Eso es el backlog. Se ejecuta por el roadmap, no todo a la vez.

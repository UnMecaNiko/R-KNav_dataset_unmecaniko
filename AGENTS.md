# AGENTS.md — Contexto principal del repositorio

> **Este es el archivo de contexto principal.** Todo agente (Claude Code, Copilot, Cursor, chatbot) y todo humano que trabaje aquí debe leerlo primero. `CLAUDE.md` y `.github/copilot-instructions.md` solo apuntan a él.

## Qué es este repositorio

Lab de trabajo de **Nicolas Velasquez Lopez (`unmecaniko`)** sobre el dataset **[R-KNav](https://huggingface.co/datasets/robotcom/R-KNav_dataset)** de [Robot.com](https://www.robot.com/) (antes Kiwibot): datos reales de navegación en acera de la flota R-Kiwi, publicados en formato LeRobot.

El objetivo no es republicar el dataset. Es **estudiarlo, analizarlo y construir pruebas** (mapas, odometría, replay en TurtleBot, Nav2, más adelante políticas de visión) para aprender herramientas de robótica y Physical AI, con artefactos públicos que cierren brechas del perfil.

Identidad, trayectoria y reglas globales de Nicolas viven en el repositorio principal:

**[github.com/UnMecaNiko/unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects)** — empezar por su [`AGENTS.md`](https://github.com/UnMecaNiko/unmecaniko-projects/blob/main/AGENTS.md).

Este repo **no sustituye** esa base. Aquí solo está el contexto del lab R-KNav. Perfil corto: [context/about-unmecaniko.md](context/about-unmecaniko.md). Enlaces: [context/related-repositories.md](context/related-repositories.md).

## Arquitectura

Una sola capa de trabajo (español). No alimenta unmecaniko.com.

| Carpeta | Qué es |
|---|---|
| `context/` | Quién es Nicolas (resumen), repos relacionados, propósito de este lab. |
| `knowledge/` | Fuente de la verdad de *este* proyecto: dataset, conceptos, herramientas, diseño de experimentos. |
| `experiments/` | Código y notebooks de las pruebas. Cada una enlaza su ficha en `knowledge/experiments/`. |
| `planning/` | Changelog y pendientes de **este** repositorio. |
| `data/` | Descargas locales del dataset. **Ignorada por git.** No commitear. |

- **Contenido en español.** Lengua de trabajo de Nicolas.
- **Nombres de carpeta y archivo en inglés.**
- El dataset original permanece en Hugging Face. Aquí van notas, scripts y resultados ligeros (tablas, gráficos chicos).

## Reglas para agentes

### 1. Cero secretos y cero redistribución del dataset

El repositorio puede ser público. Cualquier archivo aquí se trata como publicado.

- No commitear tokens, `.env` reales, ni pesos de modelos grandes.
- **No commitear** parquet, mp4, mcap ni copias de R-KNav. La [licencia](https://huggingface.co/datasets/robotcom/R-KNav_dataset) es no comercial y **prohíbe redistribuir** el dataset. Referenciar `robotcom/R-KNav_sample` y `robotcom/R-KNav_dataset`.
- Código propio: se puede publicar. Modelos entrenados con R-KNav, si se publican, heredan la restricción no comercial y la atribución *Robot.com R-KNav Dataset*.

### 2. Idioma y formato

- Narrativa → Markdown. Inventarios y parámetros → YAML.
- Lo desconocido: `> ⏳ PENDIENTE: <qué falta y cómo obtenerlo>`. Nunca inventar cifras del dataset ni de Robot.com.

### 3. Referenciar GitHub y Hugging Face, nunca rutas locales

Prohibido escribir `C:\Users\...` como forma de localizar conocimiento. Dataset: URL del Hub. Identidad: `unmecaniko-projects`. Excepción: documentar dónde vive un secreto que no puede estar en git.

### 4. Tres capas que no se mezclan

```
Robot / sim          ROS 2, Nav2, RViz, /cmd_vel
Grabación            rosbag → Rosetta → LeRobot (parquet + mp4)
Aprendizaje          LeRobot / PyTorch  (videos → policy)
```

- **Nav2** escribe `/cmd_vel` en el stack clásico. No come MP4.
- **Rosetta** traduce ROS 2 ↔ LeRobot. No es un plugin de Nav2.
- **LeRobot Dataset Visualizer** inspecciona el Hub. No entrenar ahí.
- **Entrenar con video** es otro hilo (`lerobot`). No bloquea mapas ni TurtleBot.
- **Isaac Sim/Lab** sí es familia NVIDIA útil (mismo formato / acción `twist`). **Alpamayo** (VLA de auto) no es el primer experimento: otro vehículo, otros sensores.

Detalle: [knowledge/concepts/layers.md](knowledge/concepts/layers.md).

### 5. Datos técnicos: validar y citar

Ante duda de formato LeRobot, Nav2, OSRM o el dataset: buscar fuente oficial, citar URL y fecha. El README de Hugging Face manda sobre recuerdos de conversaciones.

### 6. Planeación viva

Al terminar trabajo: [planning/changelog.md](planning/changelog.md) y [planning/pendientes.md](planning/pendientes.md). Un pendiente resuelto se borra de pendientes y queda en el changelog.

### 7. Flujo de git

- Commits automáticos, sin pedir autorización, sobre `main` o una rama.
- `git pull` al iniciar sesión.
- `git push` a `origin` automático tras cada commit.
- `main` por defecto. Rama `tipo/proposito` solo si hay que aislar.
- Merge a `main` requiere autorización explícita; luego fast-forward, sin PR, borrar la rama remota.
- Identidad de commits: `Nicolas Velasquez Lopez <unmecaniko@gmail.com>`.

## Mapa del repositorio

```
AGENTS.md                 ← estás aquí
CLAUDE.md                 solo referencia a AGENTS.md
README.md                 índice para humanos
context/                  quién, para qué, repos relacionados
knowledge/
  dataset/                qué es R-KNav, acceso, schema, licencia, pipeline
  concepts/               capas, VLM/VLA, jerky, teleop vs autónomo
  tools/                  visualizador, Rosetta, ROS 2/RViz, OSRM, NVIDIA
  experiments/            diseño de cada prueba (aún sin código)
experiments/              código cuando exista
planning/                 changelog.md, pendientes.md
data/                     local, gitignored
```

## Lectura mínima para un agente nuevo

1. Este archivo.
2. [context/repository-purpose.md](context/repository-purpose.md)
3. [knowledge/dataset/overview.md](knowledge/dataset/overview.md)
4. [knowledge/experiments/roadmap.md](knowledge/experiments/roadmap.md)
5. Si hace falta identidad o carrera: [unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects)

## Flujos frecuentes

| Quiero… | Entonces… |
|---|---|
| Entender el dataset | [knowledge/dataset/overview.md](knowledge/dataset/overview.md) |
| Descargar o pedir acceso | [knowledge/dataset/access.md](knowledge/dataset/access.md) |
| Ver el sample en el visualizador | [knowledge/tools/lerobot-visualizer.md](knowledge/tools/lerobot-visualizer.md) |
| Saber qué experimento toca | [knowledge/experiments/roadmap.md](knowledge/experiments/roadmap.md) |
| ROS 2 / RViz / Nav2 | [knowledge/tools/ros2-rviz.md](knowledge/tools/ros2-rviz.md) — tutoriales oficiales, no reescribirlos |
| Quién es Nicolas | [context/about-unmecaniko.md](context/about-unmecaniko.md) y el repo principal |
| Qué cambió aquí | [planning/changelog.md](planning/changelog.md) |

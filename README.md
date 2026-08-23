# R-KNav lab — unmecaniko

Working lab of [Nicolas Velasquez Lopez](https://www.unmecaniko.com) (`unmecaniko`) on the [R-KNav dataset](https://huggingface.co/datasets/robotcom/R-KNav_dataset) (Robot.com sidewalk navigation, LeRobot format).

This repository holds **notes, experiment design and later code**. It does **not** host a copy of the dataset. R-KNav is licensed for non-commercial use and must not be redistributed; see [knowledge/dataset/license.md](knowledge/dataset/license.md).

Human index below is in Spanish (working language). Agent rules: [`AGENTS.md`](AGENTS.md).

---

## Para qué existe

Estudiar un dataset de flota real y **aprender herramientas** encima: mapas (OSM/OSRM), odometría vs GPS, replay en TurtleBot (ROS 2 + RViz), Nav2, y más adelante políticas que usen las cámaras (LeRobot). Encaja con la transición de Nicolas hacia robótica + Physical AI. El contexto de identidad no se duplica: vive en [unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects).

## Mapa

| Dónde | Qué |
|---|---|
| [AGENTS.md](AGENTS.md) | Reglas para agentes |
| [context/](context/) | Quién, propósito, repos relacionados |
| [knowledge/dataset/](knowledge/dataset/) | Qué es R-KNav |
| [knowledge/experiments/roadmap.md](knowledge/experiments/roadmap.md) | Orden de las pruebas |
| [experiments/](experiments/) | Código (vacío hasta el primer experimento) |
| [planning/pendientes.md](planning/pendientes.md) | Backlog de este lab |

## Dataset (externo)

| Recurso | URL |
|---|---|
| Sample ~30 min (abierto) | [robotcom/R-KNav_sample](https://huggingface.co/datasets/robotcom/R-KNav_sample) |
| 300 h (gated) | [robotcom/R-KNav_dataset](https://huggingface.co/datasets/robotcom/R-KNav_dataset) |
| Visualizador | [lerobot/visualize_dataset](https://huggingface.co/spaces/lerobot/visualize_dataset) |
| 10 000 h | Pedir a Autonomy: `airobotics@kiwicampus.com` |

## Estado

Arranque 2026-08-23: contexto volcado desde la sesión de exploración. Aún no hay código. Primeros experimentos previstos: mapa GPS, dead reckoning vs GPS, replay de `cmd_vel` en TurtleBot.

## Licencia de *este* repo

Notas y código propio: ver [LICENSE](LICENSE). El dataset R-KNav sigue siendo de Robot.com Holdings, Inc.; no se incluye aquí.

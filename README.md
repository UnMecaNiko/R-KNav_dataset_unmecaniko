# R-KNav lab — unmecaniko

Working lab of [Nicolas Velasquez Lopez](https://www.unmecaniko.com) (`unmecaniko`) on the [R-KNav dataset](https://huggingface.co/datasets/robotcom/R-KNav_dataset) (Robot.com sidewalk navigation, LeRobot format).

This repository holds **notes, experiment design and later code**. It does **not** host a copy of the dataset. R-KNav is licensed for non-commercial use and must not be redistributed; see [knowledge/dataset/license.md](knowledge/dataset/license.md).

Agent rules: [`AGENTS.md`](AGENTS.md).

---

## Why it exists

To study a real fleet dataset and **learn tooling** on top of it: maps (OSM/OSRM), odometry vs GPS, TurtleBot replay (ROS 2 + RViz), Nav2, and later policies that use the cameras (LeRobot). It fits Nicolas's transition toward robotics + Physical AI. Identity context is not duplicated here: it lives in [unmecaniko-projects](https://github.com/UnMecaNiko/unmecaniko-projects).

## Map

| Where | What |
|---|---|
| [AGENTS.md](AGENTS.md) | Rules for agents |
| [context/](context/) | Who, purpose, related repos |
| [knowledge/dataset/](knowledge/dataset/) | What R-KNav is |
| [knowledge/dataset/local-download.md](knowledge/dataset/local-download.md) | Recreate the git-ignored local dataset |
| [knowledge/experiments/roadmap.md](knowledge/experiments/roadmap.md) | Order of the experiments |
| [experiments/](experiments/) | Design and results per experiment |
| [harness/](harness/) | Feature contract, tests, architecture, progress log |
| [harness/features.md](harness/features.md) | What is built, and what is actually verified |
| [planning/todo.md](planning/todo.md) | Backlog of this lab |

## Dataset (external)

| Resource | URL |
|---|---|
| ~30 min sample (open) | [robotcom/R-KNav_sample](https://huggingface.co/datasets/robotcom/R-KNav_sample) |
| 300 h (gated) | [robotcom/R-KNav_dataset](https://huggingface.co/datasets/robotcom/R-KNav_dataset) |
| Visualizer | [lerobot/visualize_dataset](https://huggingface.co/spaces/lerobot/visualize_dataset) |
| 10,000 h | Request from Autonomy: `airobotics@kiwicampus.com` |

## Status

Experiment 1 is running. The LeRobot Dataset Visualizer fork shows a synchronized route map inside the episode view, and a **Map** tab drawing every episode's route on one basemap. Code lives in a fork of `huggingface/lerobot-dataset-visualizer`, not here — see [harness/architecture.md](harness/architecture.md).

Next: verify the Map tab in a browser, then [iteration 2](experiments/lerobot-map-visualizer/dataset-map-iteration-2-plan.md) — heatmap, time-of-day colouring, hover detail, distance statistics.

## License of *this* repo

Own notes and code: see [LICENSE](LICENSE). The R-KNav dataset still belongs to Robot.com Holdings, Inc.; it is not included here.

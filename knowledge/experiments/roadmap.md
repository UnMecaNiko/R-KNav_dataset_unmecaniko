# Experiment roadmap

Agreed order (session 2026-08-23). Each item has a design note. Code, once it exists, goes in `experiments/<slug>/`.

| # | Experiment | Layer | Status |
|---|---|---|---|
| 0 | Validate `waypoints` (WGS84?) | data | pending |
| 1 | Episode map ± OSRM | analysis | pending |
| 2 | Dead reckoning \(v,\omega\) vs GPS | analysis | pending |
| 3 | `/cmd_vel` replay on TurtleBot + RViz | ROS 2 | pending |
| 4 | Nav2 following the route (not the video) | ROS 2 | pending |
| 5 | Policy over the cameras (LeRobot) | learning | later |
| 6 | Policy → robot (Rosetta or another bridge) | closing the loop | much later |
| — | Isaac Sim rover | NVIDIA | optional, does not block 1–4 |
| — | Google Earth elevation | — | **discarded** |

0 is the gate for 1 and 2. 3 does not require a realistic map. 4 requires 1 (the route). 5 does not block 1–4.

Do not open a notebook that duplicates the visualizer (jerky, histograms). The Space already does that.

## Definition of "done"

An experiment is done when there is a folder in `experiments/`, a README linking this design note, and a reproducible result (script + figure, or a bag/sim demo) **without** uploading the dataset.

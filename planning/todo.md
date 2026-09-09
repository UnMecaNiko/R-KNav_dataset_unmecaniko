# Todo

## Harness

- [ ] **Add a browser sensor** (Playwright MCP, or a Playwright suite in the fork). The single highest-value gap:
      every defect found in the 2026-09-07 round was invisible to the unit tests
- [ ] Read the distinct `observation.state.time_of_day` values from the gated dataset — the sample has only
      `Daytime` and `Night`, and iteration 2's colouring depends on the real domain

## Kickoff

- [ ] Clone/use this repo as the Cursor workspace during lab sessions
- [ ] Decide TurtleBot 3 vs 4 for the replay

## Experiments (detail in knowledge/experiments/)

- [ ] 1a — **push the fork.** It has no `origin` remote: 2,300+ lines exist on one disk only
- [ ] 1b — verify the dataset Map tab in a browser and set `passes` in `harness/feature-list.json`
- [ ] 1c — dataset map iteration 2: heatmap, time-of-day colouring, hover detail, distance statistics
      (design: `experiments/lerobot-map-visualizer/dataset-map-iteration-2-plan.md`)
- [ ] 1d — decide the upstream path for the episode map, and pick a tile provider before any public deployment
- [ ] 2 — dead reckoning vs GPS
- [ ] 3 — TurtleBot replay
- [ ] 4 — Nav2 over the route
- [ ] 5 — LeRobot policy (parked)
- [ ] 6 — bridge to the robot (parked)

## Out of scope / do not do

- Google Earth / Google Elevation API
- Alpamayo as the first experiment
- Uploading the dataset to this GitHub repo
- Redoing in a notebook what the Dataset Visualizer already does

# Progress log

Append-only. **Read this first in a new session**, then [feature-list.json](feature-list.json).

Newest entry at the top. One entry per working session: what changed, what was measured, what was left open. Prose belongs in [../planning/changelog.md](../planning/changelog.md); this file is for orientation.

---

## 2026-09-08 — Dataset map, iteration 1, and this harness

**State on arrival:** episode map implemented and verified; fork on `feat/episode-route-map`, two commits, no `origin` remote. No harness layer in this repo.

**Done**

- Reviewed the previous session's work and re-ran its claims rather than trusting them: 247 tests pass, type-check and lint clean, build exit 0. The reported figures held.
- Added `ARG`/`ENV` for every `NEXT_PUBLIC_*` map variable to the fork's Dockerfile (commit `ac4f606`). Without it the documented configuration could not reach a Docker or Hugging Face Space build at all.
- Built dataset-map iteration 1: a **Map** tab after Episodes drawing every episode's route on one basemap, with the episode map's start/end symbols.
  - New pure module `utils/datasetRoutes.ts` (radial filter → input cap → Douglas-Peucker → vertex cap) with 30 unit tests.
  - New loader `loadAllEpisodeRoutes` reading three columns, one fetch per shard.
  - New component `components/dataset-map.tsx`, canvas renderer, viewport-scoped endpoint markers.
  - Extracted the marker shapes to `utils/geoMarkers.ts` so both maps cannot drift apart.
- Wrote this harness layer against the Anthropic, OpenAI and Fowler articles.

**Measured**

- 18,054 frames → **620 drawn vertices** across 14 routes at a 50 cm tolerance; shape retained (episode 0: 47 vertices, episode 7: 80).
- 5,340 distinct consecutive positions in the sample — matches the figure recorded independently on 2026-09-07.
- Reading 3 columns of the full shard: **34–55 ms**; geometry for all 14 routes: **11–14 ms**.
- Episode page bundle 56.7 kB → **58.1 kB**; shared bundle unchanged at 103 kB, so Leaflet stays code-split.

**Found**

- A test of my own caught a real defect: Douglas-Peucker took **61 s** on 60,000 corner-only points — its quadratic worst case. Fixed with a radial pre-pass and a 10,000-point input cap; the test now asserts the bound.
- A 3 m tolerance destroyed route shape (episode 0 collapsed to 2 vertices). Swept the tolerance and settled on 50 cm, the float32 quantization floor.
- `observation.state.time_of_day` exists in the data and is **constant per episode**, but takes only **two** values in the sample: `Daytime` and `Night`. The requested midday category has no source. Recorded in the iteration 2 plan.
- The dataset also carries `weather`, `road_type` and `surface` as per-frame strings — unused so far, and useful for iteration 2.

**Open**

- The Map tab has **not been verified in a browser**. Automated sensors pass; the visual behaviour is unconfirmed. Feature list entries reflect that.
- No browser sensor exists in this repository at all. Highest-value harness gap.
- The fork still has no `origin` remote — the whole implementation exists on one disk.
- Tile provider must change before any public deployment.

---

## 2026-09-07 — Episode map implemented and verified

Synchronized single-episode route map built in the fork and verified against the production build: 217 tests, 196/196 per-episode browser checks against values measured from the parquet, 40/40 robustness checks, 10/10 control checks. Five defects found in the browser that unit tests could not catch, all fixed. Full write-up: [../experiments/lerobot-map-visualizer/implementation-results.md](../experiments/lerobot-map-visualizer/implementation-results.md).

## 2026-09-06 — Planning package and local dataset

Design, data contract, technical plan and phased handoff written for the episode map. Public sample downloaded and manifest-verified into `data/raw/`.

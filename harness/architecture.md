# Architecture

A feedforward guide: read this *before* changing code, so the change lands in the right layer. Module boundaries here are invariants, not preferences — the linter and type checker cannot see most of them.

## Two repositories, on purpose

```
R-KNav_dataset_unmecaniko          this repo — design, evidence, harness. No app code.
  ↕ (linked by documents, not by imports)
lerobot-dataset-visualizer fork    branch feat/episode-route-map — all app code.
```

The lab keeps the product design, the measured data contract and the verification record. The fork keeps the implementation, because it is a fork of an Apache-2.0 upstream that the feature is meant to be proposed back to. Vendoring the app here would make that proposal impossible to extract.

> ⏳ TODO: the fork has no `origin` remote. Its only copy is on one machine. Pushing it is the highest-priority item in [../planning/todo.md](../planning/todo.md).

## Layers in the fork

```
meta/info.json ──▶ resolveGeoFeature()          which feature holds coordinates
                          │
                          ├── one episode ──────────────────────────────────┐
                          │   data parquet, FULL rows                       │
                          │        ↓ extractGeoTrack()                      │
                          │   EpisodeData.geoTrack ──▶ episode-map.tsx      │
                          │        ↑ TimeContext.subscribe / seek           │
                          │                                                 │
                          └── all episodes ─────────────────────────────────┤
                              meta/episodes ──▶ row ranges per episode      │
                              data parquet, 3 COLUMNS, one fetch per shard  │
                                   ↓ extractGeoTrack() per row range        │
                                   ↓ buildEpisodeRoute()  (datasetRoutes)   │
                              DatasetRoutes ──▶ dataset-map.tsx             │
                                                                            │
                              utils/geoMarkers.ts — shared symbols ─────────┘
```

| Module | Layer | Rule |
|---|---|---|
| `utils/geoTrack.ts` | pure | No React, no Leaflet, no fetch. Resolution, validation, extraction, lookup. |
| `utils/datasetRoutes.ts` | pure | No React, no Leaflet, no fetch. Geometry reduction only. |
| `utils/geoMarkers.ts` | pure-ish | Shapes and colours shared by both maps. Takes `L` as an argument; never imports Leaflet at module scope. |
| `utils/geoConfig.ts` | config | Every value read as a **literal** `process.env.NEXT_PUBLIC_*` member access. |
| `fetch-data.ts` | data | Fetch, slice, reduce. Runs in the browser — `episode-viewer.tsx` is `"use client"`. |
| `components/episode-map.tsx` | view | Imperative Leaflet leaf. No `setState` on a clock tick. |
| `components/dataset-map.tsx` | view | Imperative Leaflet leaf. Canvas renderer; viewport-scoped DOM markers. |

## Invariants

**1. Never guess that a feature is geographic.** R-KNav's `observation.state` (a twist pair) and `observation.state.waypoints` (longitude/latitude) are both `float32[2]`. Resolution runs config → `names` → allowlist → *no map*. Adding a shape-based fallback would plot a velocity in the Gulf of Guinea.

**2. Never draw a local frame on a world basemap.** If every numeric row is outside geographic range, the feature is metric, not WGS84. Drop it.

**3. `NEXT_PUBLIC_*` is a build-time value.** `next build` inlines it into the client bundle. `docker run -e` does nothing. Read it as a literal member access, and pass it as a Docker build arg — the Dockerfile declares each one.

**4. The map follows the clock; it never drives it.** The episode map's only write is a user click calling `seek(t)`. The primary video stays the sole reporter of playback time. There is one clock.

**5. Reduce geometry before React sees it.** The dataset map must never receive a per-frame track. Reduction happens in the data layer, and the budgets are env-tunable constants in `fetch-data.ts`.

**6. Bound the expensive step.** Douglas-Peucker is quadratic on adversarial input. `MAX_SIMPLIFY_INPUT` caps what it sees. Do not remove that cap because the sample is small — it exists for the gated dataset.

## Scaling: sample vs. the real thing

The public sample is 14 episodes / 18,054 frames / a 736 KB data parquet. The gated dataset is ~300 h — roughly 10^7 frames. Everything in the dataset-map path is sized for the second number:

| Lever | Where | Default |
|---|---|---|
| Episodes read | `MAX_MAP_EPISODES` | 500, evenly sampled across the dataset |
| Vertices per route | `MAX_MAP_VERTICES_PER_EPISODE` | 400 |
| Simplification tolerance | `MAP_SIMPLIFY_TOLERANCE_CM` | 50 cm — the float32 quantization floor |
| Douglas-Peucker input | `MAX_SIMPLIFY_INPUT` | 10,000 points |
| Endpoint symbols on screen | `MAX_ENDPOINT_ROUTES` | 150 routes |

When the map is sampling rather than showing everything, the readout says so. A map that silently displays 500 of 5,000 episodes while looking complete is worse than one that admits it.

**What does not yet scale**, and is the substance of iteration 2: the loader reads every sampled episode's shard up front. At thousands of episodes that should become viewport-driven — bounding boxes from `meta/episodes` first, full geometry only for what is on screen. See the [iteration 2 plan](../experiments/lerobot-map-visualizer/dataset-map-iteration-2-plan.md).

# Features

Human-readable view of [feature-list.json](feature-list.json), which is the authoritative record. Statuses here must match it.

**Verified** means an agent ran the verification steps in the feature list and recorded the date. **Built, unverified** means the code exists and the automated sensors pass, but the listed verification method — usually a browser — has not been run against it. **Planned** means not built.

## Episode map — one route, tied to the playback clock

| Feature | Status |
|---|---|
| Interactive basemap with the episode's full recorded route | ✅ Verified 2026-09-07 |
| Marker tracks the shared clock; route, chart, playback bar and `?t=` all stay in step | ✅ Verified 2026-09-07 |
| Start / end / current position as distinct **shapes**, not colours | ✅ Verified 2026-09-07 |
| Click the route or an endpoint to seek | ✅ Verified 2026-09-07 |
| Follow-the-robot toggle and reset view | ✅ Verified 2026-09-07 |

## Dataset map — every route, one basemap

| Feature | Status |
|---|---|
| A **Map** tab immediately after Episodes | 🔧 Built 2026-09-08, unverified |
| Every loaded episode's route drawn on one map, framed to fit them all | 🔧 Built 2026-09-08, unverified |
| Pan and zoom across the whole extent | 🔧 Built 2026-09-08, unverified |
| Start / end symbols per route, identical to the episode map's | 🔧 Built 2026-09-08, unverified |
| Endpoint symbols limited to routes in the current viewport | 🔧 Built 2026-09-08, unverified |
| Loads only when the tab is opened | 🔧 Built 2026-09-08, unverified |
| Readout states route count, sampling, and the development basemap | 🔧 Built 2026-09-08, unverified |

## Data integrity — the rules that outrank any feature

| Feature | Status |
|---|---|
| A geographic feature is resolved by config, `names`, or a documented allowlist — never guessed from shape | ✅ Verified 2026-09-07 |
| A local/metric coordinate frame is never drawn on a world basemap | ✅ Verified 2026-09-08 |
| Datasets without geography render exactly as upstream | ⚠️ Verified for the episode map only |
| No R-KNav artifact is committed; data is fetched at runtime under the viewer's own credentials | ✅ Verified 2026-09-08 |

## Performance and scale

| Feature | Status |
|---|---|
| Routes reduced by radial filter + Douglas-Peucker, preserving corners | ✅ Verified 2026-09-08 — 18,054 frames → 620 vertices |
| Douglas-Peucker's quadratic worst case bounded by an input cap | ✅ Verified 2026-09-08 — 60k adversarial points under 4 s |
| Only `index`, `episode_index` and the coordinate column are read | ✅ Verified 2026-09-08 |
| One fetch per data shard, not per episode | ✅ Verified 2026-09-08 |
| Leaflet stays out of every shared bundle | ✅ Verified 2026-09-08 — shared bundle unchanged at 103 kB |

## Not built yet — iteration 2

Design: [../experiments/lerobot-map-visualizer/dataset-map-iteration-2-plan.md](../experiments/lerobot-map-visualizer/dataset-map-iteration-2-plan.md)

| Feature | Note |
|---|---|
| Density heatmap when zoomed out | "10 episodes here, 15 there" |
| Routes coloured by time of day | ⚠️ The dataset publishes **two** values, `Daytime` and `Night` — there is no midday category. See the plan. |
| Hover a route for episode, time of day and distance in metres | Needs a hit-test layer; the current canvas polylines are non-interactive |
| Distance statistics per zone, and the most-travelled points | The end product of iteration 2 |

## Explicitly out of scope

- Copying R-KNav data into either repository.
- OSRM route matching. The first maps show the recorded track, nothing inferred.
- A second playback clock.
- Treating any two-element feature as coordinates.

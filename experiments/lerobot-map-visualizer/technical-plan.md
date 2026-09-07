# Technical plan

## Verified upstream architecture

The visualizer is an Apache-2.0 Next.js/React/TypeScript application. At the checked upstream baseline it uses Bun, `hyparquet`, Recharts, Three.js, and Tailwind CSS. It does not include a map dependency.

Relevant upstream files:

| Area | Upstream path | Finding |
|---|---|---|
| Episode composition | `src/app/[org]/[dataset]/[episode]/episode-viewer.tsx` | Fetches one episode, creates `TimeProvider`, renders videos, charts, and playback controls |
| Data loading | `src/app/[org]/[dataset]/[episode]/fetch-data.ts` | Reads v3 episode offsets, selected Parquet rows, numeric features, tasks, and video segments |
| Shared clock | `src/context/time-context.tsx` | Exposes `currentTime`, `seek`, `subscribe`, playback state, and external-seek version |
| Video sync | `src/components/simple-videos-player.tsx` | Uses shared time; primary video reports playback time and other videos follow |
| Chart sync | `src/components/data-recharts.tsx` | Reads shared time and calls shared `seek` on chart interaction |

The current application intentionally keeps high-frequency time subscriptions in leaf components to avoid re-rendering the large episode component. The map must preserve that pattern.

## Verified R-KNav contract

- Dataset format: LeRobot v3.0.
- FPS: 10.
- Sample: 14 episodes and 18,054 frame rows.
- Geographic candidate: `observation.state.waypoints`, `float32`, shape `[2]`.
- Published order: `[longitude, latitude]`.
- Observed sample extents: longitude `-118.417488...` to `-68.669060...`; latitude `30.209423...` to `47.921959...`.
- Each frame row has local `timestamp`, `frame_index`, global `index`, and `episode_index`.
- Episode metadata supplies `[dataset_from_index, dataset_to_index)` and per-camera video time offsets.

The values and US extents are consistent with geographic longitude/latitude. No explicit CRS identifier is present in `info.json`, so the implementation records an assumption of WGS84-compatible longitude/latitude rather than claiming a formally tagged CRS.

## Proposed data flow

```text
info.json
  └─ resolve explicit/recognized geographic feature

episode metadata parquet
  └─ locate current episode's data shard and row interval

episode frame parquet rows
  ├─ existing chartDataGroups / flatChartData
  └─ new geoTrack [{timestamp, frameIndex, longitude, latitude, valid}]

TimeProvider
  ├─ videos
  ├─ charts
  ├─ playback bar
  └─ EpisodeMap (leaf subscriber)
```

## Proposed modules

### Geographic feature resolver

Responsibilities:

- read the proposed configuration;
- verify that the feature exists and is numeric with two components;
- determine coordinate order;
- return a typed mapping or a reason why mapping is unavailable;
- never infer geography from shape alone.

### Geographic row extractor

Run after the full current-episode row slice is decoded and before chart downsampling. Emit timestamp, frame index, and coordinates. Keep raw frame ordering. Invalid rows are flagged or excluded with a count.

Do not use `stats.json` to reconstruct a route. It contains aggregates, and this sample's stored quantiles are not reliable global quantiles.

### Episode map component

Recommended first implementation: Leaflet loaded client-side and lazily, using the library directly rather than adding a React wrapper. This minimizes React-version coupling and avoids server-side access to browser globals.

Responsibilities:

- create and destroy the map instance;
- add a configurable tile layer and visible attribution;
- render route, completed segment, start/end markers, and current marker;
- fit bounds only on episode change or explicit reset;
- subscribe directly to the shared clock;
- update Leaflet layers through refs rather than re-rendering the parent tree;
- translate a route click into the existing `seek` call.

### Episode layout integration

Insert the lazily loaded map in the current Episodes content after video/task context and before charts, using responsive layout rules. Do not add a top-level map tab for the first release.

## Time-to-position mapping

Use timestamps rather than assuming `frameIndex === currentTime * fps`, because future datasets may contain irregular or missing samples.

For a clock time `t`:

1. Binary-search the ordered valid track timestamps.
2. Select the nearest sample for frame-faithful display.
3. Optionally interpolate visually between adjacent valid coordinates only when both timestamps are close and monotonic.
4. Display the actual selected frame coordinate, even if the marker animation is interpolated.

The R-KNav sample's longest episode has 3,289 rows. The upstream chart loader currently caps sampled episode points at 4,000, so the sample is not reduced. The map should nevertheless extract from full episode rows so correctness does not depend on the chart sampling threshold.

## Route rendering and scale

- Preserve all points for the R-KNav sample.
- For much longer episodes, keep exact lookup data but simplify only the displayed polyline after measuring browser performance.
- Never drop start/end points.
- Split on invalid runs or longitude discontinuities.
- Do not call OSRM in the rendering path.

## Tile service and attribution

The tile URL must be configurable. A development default may use the OSM Standard raster endpoint for normal human interactive viewing, with visible `© OpenStreetMap contributors` attribution. The application must not prefetch, bulk-download, suppress browser caching, or imply an SLA. Review the current [OSMF tile usage policy](https://operations.osmfoundation.org/policies/tiles/) before public deployment; select a suitable hosted provider or self-hosting if traffic outgrows permitted use.

## Dataset access and licensing

- Continue fetching dataset artifacts from their original Hugging Face repository.
- Reuse the visualizer's existing Hugging Face authentication path for gated data.
- Never bundle R-KNav Parquet, video, exact derived route files, or tokens with the visualizer fork.
- Sample coordinates are already public, but implementation should not create an unnecessary second dataset distribution.
- A public visualizer fork retains the upstream Apache-2.0 notices. Dataset licensing remains independent.

## Performance constraints

- Lazy-load Leaflet and map code.
- Do not make `EpisodeViewerInner` subscribe to every time tick.
- Update marker/layers imperatively in the map leaf component.
- Fit bounds once per episode, not per frame.
- Avoid creating thousands of individual DOM markers; use one polyline and a small fixed marker set.
- Do not fetch any new dataset file if the needed coordinates already exist in the decoded episode rows.

## Security and privacy

- Treat remote dataset metadata and tasks as untrusted content.
- Do not inject coordinate labels as HTML.
- Validate tile and dataset URLs through existing routing/configuration patterns.
- Do not send coordinates to OSRM or another third-party routing API in the first release.
- Make the map unavailable rather than guessing when coordinate order or CRS is unknown.

## Source references

Checked on 2026-09-06:

- [Visualizer repository](https://github.com/huggingface/lerobot-dataset-visualizer)
- [Episode viewer](https://github.com/huggingface/lerobot-dataset-visualizer/blob/main/src/app/%5Borg%5D/%5Bdataset%5D/%5Bepisode%5D/episode-viewer.tsx)
- [Episode data loader](https://github.com/huggingface/lerobot-dataset-visualizer/blob/main/src/app/%5Borg%5D/%5Bdataset%5D/%5Bepisode%5D/fetch-data.ts)
- [Shared time context](https://github.com/huggingface/lerobot-dataset-visualizer/blob/main/src/context/time-context.tsx)
- [LeRobot v3 design](https://github.com/huggingface/lerobot/blob/main/docs/source/lerobot-dataset-v3.mdx)
- [Leaflet reference](https://leafletjs.com/reference.html)
- [OSMF tile usage policy](https://operations.osmfoundation.org/policies/tiles/)

